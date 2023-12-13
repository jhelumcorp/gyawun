import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';

import '../../ui/text_styles.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  @override
  Widget build(BuildContext context) {
    bool enabled = Hive.box('settings')
        .get('equalizerEnabled', defaultValue: false) as bool;
    bool loudnessEnabled = Hive.box('settings')
        .get('loudnessEnabled', defaultValue: false) as bool;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S().loudnessAndEqualizer,
              style: mediumTextStyle(context, bold: false)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight > 600 ? 600 : null,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListTile(
                      title: Text(S.of(context).loudnessEnhancer),
                      trailing: CupertinoSwitch(
                        value: loudnessEnabled,
                        onChanged: (value) {
                          loudnessEnabled = value;
                          Hive.box('settings').put('loudnessEnabled', value);
                          GetIt.I<AndroidLoudnessEnhancer>().setEnabled(value);
                          setState(() {});
                        },
                      ),
                      onTap: () {
                        loudnessEnabled = !loudnessEnabled;
                        Hive.box('settings')
                            .put('loudnessEnabled', loudnessEnabled);
                        GetIt.I<AndroidLoudnessEnhancer>()
                            .setEnabled(loudnessEnabled);
                        setState(() {});
                      },
                    ),
                    const LoudnessControls(),
                    ListTile(
                      title: Text(S.of(context).enableEqualizer),
                      trailing: CupertinoSwitch(
                        value: enabled,
                        onChanged: (value) {
                          enabled = value;
                          Hive.box('settings').put('equalizerEnabled', value);
                          GetIt.I<AndroidEqualizer>().setEnabled(value);
                          setState(() {});
                        },
                      ),
                      onTap: () {
                        enabled = !enabled;
                        Hive.box('settings').put('equalizerEnabled', enabled);
                        GetIt.I<AndroidEqualizer>().setEnabled(enabled);
                        setState(() {});
                      },
                    ),

                    //
                    if (enabled)
                      FutureBuilder(
                        future: getEqParms(),
                        builder: (context, snapshot) {
                          final parameters = snapshot.data;
                          if (parameters == null) return const SizedBox();
                          return Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (var band in parameters['bands'])
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: VerticalSlider(
                                            min: parameters['minDecibels'],
                                            max: parameters['maxDecibels'],
                                            value: band['gain'],
                                            bandIndex: band['index'] as int,
                                          ),
                                        ),
                                        Text(
                                            '${band['centerFrequency'].round()} Hz'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class LoudnessControls extends StatefulWidget {
  const LoudnessControls({super.key});

  @override
  State<LoudnessControls> createState() => _LoudnessControlsState();
}

class _LoudnessControlsState extends State<LoudnessControls> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GetIt.I<AndroidLoudnessEnhancer>().targetGainStream,
        builder: (context, snapshot) {
          final targetGain = snapshot.data ?? 0.0;
          return Slider(
            min: -1,
            max: 1,
            value: targetGain,
            onChanged: (val) async {
              await GetIt.I<AndroidLoudnessEnhancer>().setTargetGain(val);
              await Hive.box('settings').put('loudness', val);
            },
            label: targetGain.toString(),
          );
        });
  }
}

class VerticalSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int bandIndex;

  const VerticalSlider({
    Key? key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.bandIndex,
  }) : super(key: key);

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  double? sliderValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text((sliderValue ?? widget.value).toStringAsFixed(2)),
        Expanded(
          child: FittedBox(
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: -pi / 2,
              child: Container(
                width: 800.0,
                height: 800.0,
                alignment: Alignment.center,
                child: Slider(
                  value: sliderValue ?? widget.value,
                  min: widget.min,
                  max: widget.max,
                  onChanged: (val) {
                    setState(() {
                      sliderValue = val;
                      setGain(widget.bandIndex, val);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<Map> getEqParms() async {
  AndroidEqualizerParameters equalizerParams =
      await GetIt.I<AndroidEqualizer>().parameters;
  final List<AndroidEqualizerBand> bands = equalizerParams.bands;
  final List<Map> bandList = bands
      .map(
        (e) => {
          'centerFrequency': e.centerFrequency,
          'gain': e.gain,
          'index': e.index,
        },
      )
      .toList();

  return {
    'maxDecibels': equalizerParams.maxDecibels,
    'minDecibels': equalizerParams.minDecibels,
    'bands': bandList
  };
}

void setGain(int bandIndex, double gain) async {
  Hive.box('settings').put('equalizerBand$bandIndex', gain);
  AndroidEqualizerParameters params =
      await GetIt.I<AndroidEqualizer>().parameters;
  await params.bands[bandIndex].setGain(gain);
}
