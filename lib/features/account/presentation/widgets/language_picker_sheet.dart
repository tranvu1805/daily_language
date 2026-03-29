import 'package:daily_language/core/bloc/locale_bloc/locale_bloc.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/account/presentation/widgets/language_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePickerSheet extends StatelessWidget {
  final String currentLocale;

  const LanguagePickerSheet({
    super.key,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.chooseLanguage,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          LanguageOptionTile(
            title: context.l10n.english,
            isSelected: currentLocale == 'en',
            onTap: () {
              context.read<LocaleBloc>().add(const LocaleChanged('en'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          LanguageOptionTile(
            title: context.l10n.vietnamese,
            isSelected: currentLocale == 'vi',
            onTap: () {
              context.read<LocaleBloc>().add(const LocaleChanged('vi'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
