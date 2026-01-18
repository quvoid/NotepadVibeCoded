import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_vader_notes/src/core/theme/theme_provider.dart';
import 'package:dart_vader_notes/src/features/settings/data/pin_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeProvider.notifier).setTheme(
                value ? ThemeMode.dark : ThemeMode.light
              );
            },
            secondary: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(),
          _PinSettingsTile(), // Extracted widget for clearer code
          const Divider(),
          const ListTile(
            title: Text('About'),
            subtitle: Text('Dart Vader Notes v1.0.0'),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}

class _PinSettingsTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PinSettingsTile> createState() => _PinSettingsTileState();
}

class _PinSettingsTileState extends ConsumerState<_PinSettingsTile> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _showSetPinDialog(PinService pinService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set App PIN'),
        content: TextField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter 4-digit PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final pin = _pinController.text;
              if (pin.length == 4) {
                await pinService.setPin(pin);
                _pinController.clear();
                if (mounted) Navigator.pop(context);
                setState(() {}); // Refresh UI
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _removePin(PinService pinService) async {
    await pinService.removePin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pinService = ref.watch(pinServiceProvider);
    final hasPin = pinService.hasPin;

    return ListTile(
      title: const Text('Security PIN'),
      subtitle: Text(hasPin ? 'PIN is set (Tap to remove)' : 'Tap to set PIN'),
      leading: Icon(hasPin ? Icons.lock : Icons.lock_open),
      onTap: () {
        if (hasPin) {
          _removePin(pinService);
        } else {
          _showSetPinDialog(pinService);
        }
      },
    );
  }
}
