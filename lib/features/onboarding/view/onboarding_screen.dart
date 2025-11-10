import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    final fullText = loc.onboardingWelcome(loc.gyawunMusic);

    final parts = fullText.split(loc.gyawunMusic);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                child: Lottie.asset(
                  'assets/animations/welcome.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 22),
              if (parts.first.isNotEmpty)
                Text(
                  parts.first,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),

              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  loc.gyawunMusic,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
              if (parts.last.isNotEmpty)
                Text(
                  parts.last,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                loc.onboardingDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isWide ? 20 : null,
                  height: 1.5,
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 240,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: context.isDesktop
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      foregroundColor: context.isDesktop
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                    ),
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      loc.getStarted,
                      style: const TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
