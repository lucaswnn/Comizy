import 'dart:math';

class NicknameGenerator {
  // 1. Defina os blocos de construção dos nomes
  static const List<String> _firstAdjectives = [
    'O brabo',
    'O rei',
    'O mago',
    'O capitão',
    'O ninja',
    'O mestre',
    'A lenda',
    'O incrível',
    'O monstro',
    'O craque',
    'O gênio',
    'O fenômeno',
    'O mito',
    'O bruxo',
    'A máquina',
    'O doutor',
    'O especialista',
    'O malandro',
    'O imparável',
    'O cabuloso',
  ];

  static const List<String> _nouns = [
    'cadastrador',
    'catalogador',
    'organizador',
    'caçador',
    'investigador',
    'detetive',
    'explorador',
    'rastreador',
    'poupador',
    'economista',
    'calculista',
    'visionário',
    'consultor',
    'fiscal',
    'auditor',
    'registrador',
    'observador',
    'guia',
    'embaixador',
    'parceiro',
    'benfeitor',
  ];

  static const List<String> _lastAdjectives = [
    'do cadastro',
    'dos produtos',
    'do estoque',
    'implacável',
    'da organização',
    'veloz',
    'da precisão',
    'supremo',
    'das galáxias',
    'das ofertas',
    'dos preços',
    'do mercado',
    'da economia',
    'dos descontos',
    'do supermercado',
    'da pechincha',
    'dos centavos',
    'do bairro',
    'do varejo',
    'da comunidade',
  ];

  static String generate(String userId) {
    final int seed = userId.hashCode;
    final random = Random(seed);

    final prefix = _firstAdjectives[random.nextInt(_firstAdjectives.length)];
    final noun = _nouns[random.nextInt(_nouns.length)];
    final suffix = _lastAdjectives[random.nextInt(_lastAdjectives.length)];

    return '$prefix $noun $suffix';
  }
}
