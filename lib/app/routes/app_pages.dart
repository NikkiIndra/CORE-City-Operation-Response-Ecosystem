import 'package:get/get.dart';

import '../data/bindings/global_binding.dart';
import '../modules/features/bus_traker/bindings/bus_traking_binding.dart';
import '../modules/features/bus_traker/views/bus_traking_view.dart';
import '../modules/features/emergency/bindings/emergency_binding.dart';
import '../modules/features/emergency/views/emergency_view.dart';
import '../modules/features/important_contacts/bindings/important_contacts_binding.dart';
import '../modules/features/important_contacts/views/important_contacts_view.dart';
import '../modules/features/report/bindings/report_binding.dart';
import '../modules/features/report/views/report_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/pages/home/views/home_view.dart';
import '../modules/pages/login/bindings/login_binding.dart';
import '../modules/pages/login/views/login_view.dart';
import '../modules/pages/onboarding/bindings/onboarding_binding.dart';
import '../modules/pages/onboarding/views/onboarding_view.dart';
import '../modules/pages/profile/bindings/profile_binding.dart';
import '../modules/pages/profile/views/profile_view.dart';
import '../modules/pages/register/bindings/register_binding.dart';
import '../modules/pages/register/views/register_view.dart';
import '../modules/pages/reset_password/bindings/reset_password_binding.dart';
import '../modules/pages/reset_password/views/reset_password_view.dart';
import '../modules/pages/setting/bindings/setting_binding.dart';
import '../modules/pages/setting/views/setting_view.dart';
import '../modules/play_report/bindings/play_report_binding.dart';
import '../modules/play_report/views/play_report_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: GlobalBindings(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.BUS_TRAKING,
      page: () => BusTrakingView(),
      binding: BusTrakingBinding(),
    ),
    GetPage(
      name: _Paths.EMERGENCY,
      page: () => EmergencyView(),
      binding: EmergencyBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.IMPORTANT_CONTACTS,
      page: () => ImportantContactsView(),
      binding: ImportantContactsBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PLAY_REPORT,
      page: () => PlayReportView(),
      binding: PlayReportBinding(),
    ),
  ];
}
