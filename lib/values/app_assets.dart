class AppAssets {
  const AppAssets._();

  static const simpleLogoSmall = 'assets/images/logo_simples_pequena.png';
  static const simpleLogo = 'assets/images/logo_simples.png';
  static const logoNameSmall = 'assets/images/logo_nome_pequena.png';
  static const logoName = 'assets/images/logo_nome.png';
  static const landingPageForeground =
      'assets/images/landing_page_foreground.png';
  static const landingPageBackground =
      'assets/images/landing_page_background.jpg';
}

class IconAssets {
  const IconAssets._();

  static const _productIconBase = 'assets/icons/product_icon';
  static const productIconCount = 8;

  static String productIcon(int index) {
    return index < 1 || index > productIconCount
        ? ''
        : '$_productIconBase$index.png';
  }
}
