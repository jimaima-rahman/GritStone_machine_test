import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_gritstone/provider/font_style_provider.dart';
import 'package:machine_test_gritstone/provider/theme_provider.dart';

class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                readOnly: true,
                label: "Select Font Family",
                child: Text(
                  "Select Font Family",
                  style: ref
                      .watch(fontFamilyProvider)[ref.watch(fontIndexProvider)]
                      .copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              RadioListTile(
                value: 0,
                groupValue: ref.watch(fontIndexProvider),
                onChanged: (value) {
                  ref
                      .read(fontIndexProvider.notifier)
                      .update((state) => value!);
                },
                title: Semantics(
                  label: 'Pacifico"',
                  readOnly: true,
                  child: Text(
                    "Pacifico",
                    style: ref.watch(fontFamilyProvider)[0].copyWith(),
                  ),
                ),
              ),
              RadioListTile(
                value: 1,
                groupValue: ref.watch(fontIndexProvider),
                onChanged: (value) {
                  ref
                      .read(fontIndexProvider.notifier)
                      .update((state) => value!);
                },
                title: Semantics(
                  readOnly: true,
                  label: 'Grape Nuts',
                  child: Text(
                    "Grape Nuts",
                    style: ref.watch(fontFamilyProvider)[1].copyWith(),
                  ),
                ),
              ),
              RadioListTile(
                value: 2,
                groupValue: ref.watch(fontIndexProvider),
                onChanged: (value) {
                  ref
                      .read(fontIndexProvider.notifier)
                      .update((state) => value!);
                },
                title: Semantics(
                  readOnly: true,
                  label: 'Poppins',
                  child: Text(
                    "Poppins",
                    style: ref.watch(fontFamilyProvider)[2].copyWith(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Semantics(
                label: 'Select Theme',
                readOnly: true,
                child: Text(
                  "Select Theme",
                  style: ref
                      .watch(fontFamilyProvider)[ref.watch(fontIndexProvider)]
                      .copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              RadioListTile(
                value: Brightness.light,
                groupValue: ref.watch(themeProvider),
                onChanged: (value) {
                  ref.read(themeProvider.notifier).update((state) => value!);
                },
                title: Semantics(
                  readOnly: true,
                  label: 'Light Theme',
                  child: Text(
                    "Light Theme",
                    style: ref.watch(
                        fontFamilyProvider)[ref.watch(fontIndexProvider)],
                  ),
                ),
              ),
              RadioListTile(
                value: Brightness.dark,
                groupValue: ref.watch(themeProvider),
                onChanged: (value) {
                  ref.read(themeProvider.notifier).update((state) => value!);
                },
                title: Semantics(
                  readOnly: true,
                  label: 'Dark Theme',
                  child: Text(
                    "Dark Theme",
                    style: ref.watch(
                        fontFamilyProvider)[ref.watch(fontIndexProvider)],
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
