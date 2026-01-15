import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpRequestPage extends StatelessWidget {
  /*
  A ideia é uma pessoa que queira ajudar, ver uma lista de oportunidades próximas
  para ajudar a precificar produtos. Ao clicar em uma oportunidade, abriria um mapa
  com os locais próximos que precisam de ajuda para precificar produtos.

  Cada item da lista tem o quem quer saber o preço (com o ícone) mais a quantidade
  de pessoas que querem saber e o nome do produto.

  Após dizer o preço, o item some da lista.

  Validação do preço: supõe-se que o preço não mude no mesmo dia.
  São necessárias pelo menos 2 precificações iguais de uma mesma oferta para validar o preço.
  
  Abaixo mostra um placar de ajudantes, com pontos ganhos por precificações feitas.
  Quanto mais pontos, mais premiações (ex: acesso a funcionalidades extras,
  assim como prêmios reais para os maiores ajudantes do mês).

  As premiações mais valiosas passam por auditorias.
  Portanto, deve-se avisar que os preços dados devem ser honestos, que ajudam a comunidade
  a reduzir custos e que fraudes podem levar à suspensão da conta. Avisar também que os
  premiados passam por auditoria.

  Pessoas que contestam de forma desonesta e que afetem a premiação de outros usuários
  também podem ser suspensas. A auditoria também leva em conta o contestante na hora da premiação.

  As premiações são por bairro.
  */
  const HelpRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.read<HelpRequestNotifier>().helpRequests.toList();

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (_, i) {
        final request = requests[i];
        return ListTile(
          leading: const Icon(Icons.volunteer_activism),
          title: Text('${request.product}'),
          subtitle: Text(
              '${request.mainOrderer} e mais ${request.numberOfOrderes} pessoas '
              'gostariam de saber o preço'),
          onTap: () {
            NavigationHelper.pushNamed(AppRoutes.productHelpRequestPage);
          },
        );
      },
    );
  }
}
