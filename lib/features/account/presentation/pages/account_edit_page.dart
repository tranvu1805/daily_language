import 'package:daily_language/core/utils/helper/validator_helper.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountEditPage extends StatefulWidget {
  const AccountEditPage({super.key});

  @override
  State<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  Account get _account => getAccountFromState(context);
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController(text: _account.fullName);
    _phoneController = TextEditingController(text: _account.phoneNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
      title: context.l10n.editProfile,
      child: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountUpdateSuccess) {
            SnackBarHelper.showSuccess(context, context.l10n.updateSuccess);
            context.pop();
          }
          if (state is AccountFailure) {
            SnackBarHelper.showFailure(context, state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AccountInProgress;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: context.l10n.fullName,
                      ),
                      validator: (value) => ValidatorHelper.validateRequired(
                        value,
                        context.l10n.required,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: context.l10n.phoneNumber,
                      ),
                      keyboardType: .phone,
                      validator: (value) => ValidatorHelper.validatePhone(
                        value,
                        context.l10n.required,
                        context.l10n.invalidPhoneNumber,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {
                              context.pop();
                            },
                            label: context.l10n.cancel,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: PrimaryButton(
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _onConfirmed,
                            label: context.l10n.confirm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onConfirmed() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<AccountBloc>().state;
      if (state is AccountSuccess) {
        final fullName = _fullNameController.text.trim();
        final phoneNumber = _phoneController.text.trim();
        context.read<AccountBloc>().add(
          AccountUpdated(
            param: UpdateAccountUseCaseParams(
              uid: state.account.uid,
              fullName: fullName,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      }
    }
  }
}
