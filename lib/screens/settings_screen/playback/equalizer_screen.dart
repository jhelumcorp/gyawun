import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../services/media_player.dart';
import '../../../services/settings_manager.dart';
import '../../../themes/text_styles.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsManager settingsManager = context.watch<SettingsManager>();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S().LoudnessAndEqualizer,
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
                        value: settingsManager.loudnessEnabled,
                        onChanged: (value) async {
                          await GetIt.I<MediaPlayer>()
                              .setLoudnessEnabled(value);
                        },
                      ),
                      onTap: () async {
                        await GetIt.I<MediaPlayer>().setLoudnessEnabled(
                            !settingsManager.loudnessEnabled);
                      },
                    ),
                    LoudnessControls(
                        disabled: settingsManager.loudnessEnabled == false),
                    ListTile(
                      title: Text(S.of(context).enableEqualizer),
                      trailing: CupertinoSwitch(
                        value: settingsManager.equalizerEnabled,
                        onChanged: (value) async {
                          await GetIt.I<MediaPlayer>()
                              .setEqualizerEnabled(value);
                        },
                      ),
                      onTap: () async {
                        await GetIt.I<MediaPlayer>().setEqualizerEnabled(
                            !settingsManager.equalizerEnabled);
                      },
                    ),
                    EqualizerControls(
                      disabled: !settingsManager.equalizerEnabled,
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

class EqualizerControls extends StatelessWidget {
  const EqualizerControls({
    this.disabled = false,
    super.key,
  });
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                          disabled: disabled,
                        ),
                      ),
                      Text('${band['centerFrequency'].round()} Hz'),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class LoudnessControls extends StatelessWidget {
  const LoudnessControls({this.disabled = false, super.key});
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: -1,
      max: 1,
      value: context.watch<SettingsManager>().loudnessTargetGain,
      onChanged: disabled
          ? null
          : (val) async {
              await GetIt.I<MediaPlayer>().setLoudnessTargetGain(val);
            },
      label: context.watch<SettingsManager>().loudnessTargetGain.toString(),
    );
    //  StreamBuilder(
    //     stream: GetIt.I<AndroidLoudnessEnhancer>().targetGainStream,
    //     builder: (context, snapshot) {
    //       final targetGain = snapshot.data ?? 0.0;
    //       return Slider(
    //         min: -1,
    //         max: 1,
    //         value: targetGain,
    //         onChanged: (val) async {
    //           await GetIt.I<AndroidLoudnessEnhancer>().setTargetGain(val);
    //           await Hive.box('settings').put('loudness', val);
    //         },
    //         label: targetGain.toString(),
    //       );
    //     });
  }
}

class VerticalSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int bandIndex;
  final bool disabled;

  const VerticalSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.bandIndex,
    this.disabled = false,
  });

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
                  onChanged: widget.disabled
                      ? null
                      : (val) {
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
  await GetIt.I<SettingsManager>().setEqualizerBandsGain(bandIndex, gain);
  AndroidEqualizerParameters params =
      await GetIt.I<AndroidEqualizer>().parameters;
  await params.bands[bandIndex].setGain(gain);
}
