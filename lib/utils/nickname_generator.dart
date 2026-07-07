import 'dart:math';

class NicknameGenerator {
  // 1. Defina os blocos de construção dos nomes
  static const List<String> _malePrefixes = [
    'O brabo',
    'O rei',
    'O mago',
    'O capitão',
    'O ninja',
    'O mestre',
    'O incrível',
    'O monstro',
    'O craque',
    'O gênio',
    'O fenômeno',
    'O mito',
    'O bruxo',
    'O doutor',
    'O especialista',
    'O malandro',
    'O imparável',
    'O cabuloso',
  ];

  static const List<String> _femalePrefixes = [
    'A lenda',
    'A máquina',
  ];

  static const List<String> _maleNouns = [
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

  static const List<String> _femaleNouns = [
    'cadastradora',
    'catalogadora',
    'organizadora',
    'caçadora',
    'investigadora',
    'detetive',
    'exploradora',
    'rastreadora',
    'poupadora',
    'economista',
    'calculista',
    'visionária',
    'consultora',
    'fiscal',
    'auditora',
    'registradora',
    'observadora',
    'guia',
    'embaixadora',
    'parceira',
    'benfeitora',
  ];

  static const List<String> _maleLastAdjectives = [
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

  static const List<String> _femaleSuffixes = [
    'do cadastro',
    'dos produtos',
    'do estoque',
    'implacável',
    'da organização',
    'veloz',
    'da precisão',
    'suprema',
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

    final isMale = random.nextBool();

    String prefix;
    String noun;
    String suffix;

    if (isMale) {
      prefix = _malePrefixes[random.nextInt(_malePrefixes.length)];
      noun = _maleNouns[random.nextInt(_maleNouns.length)];
      suffix = _maleLastAdjectives[random.nextInt(_maleLastAdjectives.length)];
    } else {
      prefix = _femalePrefixes[random.nextInt(_femalePrefixes.length)];
      noun = _femaleNouns[random.nextInt(_femaleNouns.length)];
      suffix = _femaleSuffixes[random.nextInt(_femaleSuffixes.length)];
    }

    return '$prefix $noun $suffix';
  }
}
