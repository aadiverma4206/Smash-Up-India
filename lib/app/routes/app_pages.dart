import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/splash_view.dart';
import '../../modules/auth/views/landing_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/auth/views/otp_verification_view.dart';
import '../../modules/auth/views/reset_password_view.dart';
import '../../modules/auth/views/sessions_view.dart';
import '../../modules/player/bindings/player_binding.dart';
import '../../modules/player/views/player_home_view.dart';
import '../../modules/player/views/profile_view.dart';
import '../../modules/player/views/edit_profile_view.dart';
import '../../modules/player/views/my_requests_view.dart';
import '../../modules/player/views/match_history_view.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/games/views/games_list_view.dart';
import '../../modules/games/views/find_games_view.dart';
import '../../modules/games/views/create_game_view.dart';
import '../../modules/games/views/game_checkout_view.dart';
import '../../modules/games/views/my_matches_view.dart';
import '../../modules/games/views/game_details_view.dart';
import '../../modules/courts/controllers/courts_controller.dart';
import '../../modules/courts/views/courts_list_view.dart';
import '../../modules/tournaments/views/tournaments_list_view.dart';
import '../../modules/leaderboard/views/leaderboard_view.dart';
import '../../modules/community/views/community_view.dart';
import '../../modules/wallet/bindings/wallet_binding.dart';
import '../../modules/wallet/views/wallet_view.dart';
import '../../modules/wallet/views/add_money_view.dart';
import '../../modules/wallet/views/payment_result_view.dart';
import '../../modules/wallet/views/transaction_history_view.dart';
import '../../modules/wallet/views/payment_history_view.dart';
import '../../modules/wallet/views/wallet_pin_view.dart';
import '../../modules/manager/bindings/manager_binding.dart';
import '../../modules/manager/views/manager_dashboard_view.dart';
import '../../modules/manager/views/manager_games_view.dart';
import '../../modules/manager/views/manager_game_details_view.dart';
import '../../modules/manager/views/manager_courts_view.dart';
import '../../modules/manager/views/manager_bookings_view.dart';
import '../../modules/manager/views/manager_players_view.dart';
import '../../modules/manager/views/manager_history_view.dart';
import '../../modules/cctv/bindings/cctv_binding.dart';
import '../../modules/cctv/views/cctv_list_view.dart';
import '../../modules/cctv/views/add_cctv_view.dart';
import '../../modules/cctv/views/cctv_details_view.dart';
import '../../modules/admin/bindings/admin_binding.dart';
import '../../modules/admin/views/admin_dashboard_view.dart';
import '../../modules/admin/views/admin_users_view.dart';
import '../../modules/admin/views/admin_create_manager_view.dart';
import '../../modules/videos/controllers/video_player_controller.dart';
import '../../modules/videos/views/video_player_view.dart';
import '../../core/widgets/app_loader.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.landing,
      page: () => const LandingView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const LandingView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/forgot-password',
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/forgot-verify',
      page: () => OtpVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/reset-password',
      page: () => ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/sessions',
      page: () => const SessionsView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const PlayerHomeView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.playerProfile,
      page: () => const ProfileView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: '/player/profile/edit',
      page: () => EditProfileView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.myMatches,
      page: () => const MyMatchesView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.myRequests,
      page: () => const MyRequestsView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.matchHistory,
      page: () => const MatchHistoryView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.paymentHistory,
      page: () => const PlayerPaymentHistoryView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotificationsView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.games,
      page: () => const GamesListView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.findGames,
      page: () => const FindGamesView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.createGame,
      page: () => const CreateGameView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.gameCheckout,
      page: () => const GameCheckoutView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.gameDetails,
      page: () => const GameDetailsView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: Routes.courts,
      page: () => const CourtsListView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => CourtsController())),
    ),
    GetPage(
      name: '/tournaments',
      page: () => const TournamentsListView(),
    ),
    GetPage(
      name: '/leaderboard',
      page: () => const LeaderboardView(),
    ),
    GetPage(
      name: '/community',
      page: () => const CommunityView(),
    ),
    GetPage(
      name: Routes.wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: '/wallet/add-money',
      page: () => AddMoneyView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: '/wallet/transactions',
      page: () => const TransactionHistoryView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: '/wallet/pin-setup',
      page: () => WalletPinView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: '/payment/processing',
      page: () => const Scaffold(
          body: AppLoader(message: 'Verifying payment with bank...')),
    ),
    GetPage(
      name: '/payment/result',
      page: () => const PaymentResultView(),
    ),
    GetPage(
      name: Routes.cctvDashboard,
      page: () => const ManagerDashboardView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: '/manager/games',
      page: () => const ManagerGamesView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: '/manager/games/details',
      page: () => ManagerGameDetailsView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: '/manager/courts',
      page: () => const ManagerCourtsView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: '/manager/bookings',
      page: () => const ManagerBookingsView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: Routes.managerPlayers,
      page: () => const ManagerPlayersView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: Routes.managerHistory,
      page: () => const ManagerHistoryView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: '/manager/cctv',
      page: () => const CctvListView(),
      binding: CctvBinding(),
    ),
    GetPage(
      name: '/manager/cctv/add',
      page: () => AddCctvView(),
      binding: CctvBinding(),
    ),
    GetPage(
      name: '/manager/cctv/details',
      page: () => const CctvDetailsView(),
      binding: CctvBinding(),
    ),
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: '/admin/users',
      page: () => AdminUsersView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: '/admin/managers/create',
      page: () => AdminCreateManagerView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: '/videos/player',
      page: () => const VideoPlayerView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => VideoPlayerController())),
    ),
  ];
}
