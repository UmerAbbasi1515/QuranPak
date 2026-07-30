import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';

/// Bottom sheet listing every translation the app can render.
Future<void> showTranslationPicker(BuildContext context) {
  final palette = context.palette;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: palette.surface,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  children: [
                    Text(
                      'Translation',
                      style: TextStyle(
                        fontFamily: 'InterSemibold',
                        fontSize: 17,
                        color: palette.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${QuranTranslations.all.length} available',
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 12.5,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final selectedId = AppPrefs.to.translationId.value;
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: QuranTranslations.all.length,
                    itemBuilder: (context, index) {
                      final option = QuranTranslations.all[index];
                      final selected = option.id == selectedId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? palette.primarySoft
                              : palette.surfaceAlt,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                selected ? palette.primary : Colors.transparent,
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          onTap: () {
                            AppPrefs.to.setTranslation(option.id);
                            Navigator.of(context).pop();
                          },
                          title: Text(
                            option.label,
                            style: TextStyle(
                              fontFamily: 'InterMedium',
                              fontSize: 14,
                              color: palette.text,
                            ),
                          ),
                          subtitle: Text(
                            option.nativeLabel,
                            style: TextStyle(
                              fontFamily: 'InterRegular',
                              fontSize: 12.5,
                              color: palette.textMuted,
                            ),
                          ),
                          trailing: Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color:
                                selected ? palette.primary : palette.textFaint,
                            size: 21,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        },
      );
    },
  );
}

/// The little grab handle shown at the top of every bottom sheet.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 4,
        width: 42,
        decoration: BoxDecoration(
          color: context.palette.border,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
