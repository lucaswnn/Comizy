class AppRoutes {
  const AppRoutes._();

  static const String landingPage = '/pagina_inicial';
  static const String login = '$landingPage/login';
  static const String createAccount = '$landingPage/criar_conta';
  static const String forgotPassword = '$landingPage/esqueci_senha';
  static const String tutorial = '/tutorial';
  static const String chooseFirstProducts = '$tutorial/produtos';
  static const String homePage = '/home';
  static const String searchPage = '$homePage/pesquisa';
  static const String offerRegister = '$homePage/cadastro_oferta';
  static const String productDetails = '$homePage/detalhes_produto';
  static const String shopDetails = '$homePage/detalhes_loja';
  static const String shopDetailsCategory = '$shopDetails/categoria';
  static const String userRoot = '$homePage/usuario';
  static const String buyPoints = '$userRoot/compra_pontos';
  static const String mainShowcaseProducts = '$userRoot/vitrine';
  static const String userData = '$userRoot/meus_dados';
  static const String pendingPoints = '$userRoot/pontos_pendentes';
}
