import 'package:comizy/src/screen/user/user_opinion_screen.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const introText =
        '''Está cansado de comprar itens caros, e logo depois encontrar ou saber de um preço bem melhor em outra loja? Nós também cansamos. Portanto, somos a Comizy, plataforma de busca de preços de produtos e busca de lojas.
    
Em desenvolvimento a partir do ano de 2023, a plataforma procura tornar a busca de itens uma tarefa fácil, sem a dor de cabeça de ter que realizar ligações para os estabelecimentos, sem precisar se deslocar entre diversos supermercados, assim como promover a comparação de preços entre lojas.
    
O serviço é georreferenciado, possibilitando ao usuário determinar se vale a pena se deslocar para realizar uma compra. Além disso, proporciona uma visualização mais dinâmica para planejar compras em diversas lojas.
    
Sua opinião é muito importante para nós: compartilhe suas opiniões, críticas e sugestões! Para isso, clique no botão abaixo e preencha sua visão sobre a plataforma. Dessa forma, é possível entender as reais necessidades dos usuários, a fim de tornar uma plataforma mais funcional e útil para todos.''';

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                introText,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserOpinionScreen()));
                  },
                  child: const Icon(Icons.add_comment)),
            ],
          ),
        ),
      ),
    );
  }
}
