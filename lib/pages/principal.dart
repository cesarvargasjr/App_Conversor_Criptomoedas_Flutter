// ignore_for_file: prefer_const_constructors
//import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/result_mbitcoin.dart';
import '../services/mbitcoin_api.dart';

/* import 'package:flushbar/flushbar.dart'; */
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final btcController = TextEditingController();
final ltcController = TextEditingController();
final adaController = TextEditingController();
final brlController = TextEditingController();
final uniController = TextEditingController();
final usdcController = TextEditingController();
late double btc;
late double ltc;
late double ada;
late double uni;
late double usdc;

// CÁLCULO DA COTAÇÃO DA MOEDA
double findCotation(val1, val2, val3) {
  double cotation = (val2 * val3) / val1;
  return cotation;
}

// LISTA DAS CRIPTOMOEDAS:
List<String> coins = ['BTC', 'LTC', 'ADA', 'UNI', 'USDC'];

// BUSCA DOS DADOS DE CADA CRITOMOEDA NA API
Future<List> getData() async {
  List<ResultApi> list = await Future.wait(
      coins.map((idCoin) => MBitcoinService.fetchCoin(idCoin)));
  return list.map((response) {
    return response;
  }).toList();
}

// SET PARA COMEÇAR COM O "BTC" SELECIONADO
class _HomePageState extends State<HomePage> {
  String selectController = 'BTC';

  @override
  void dispose() {
    super.dispose();
  }

// FLUSHBAR
/*   final List<Flushbar> flushBars = [];
  var titleSnackBar = '';
  var massageSnackBar = ''; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // SEMANTICS UTILIZADO PARA A LEITURA POR VOZ (ACESSIBILIDADE)
          title: Semantics(
            child: const Text(
              'Cryptocurrency Converter',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            label: 'Cryptocurrency Converter',
          ),
          centerTitle: true,
          toolbarHeight: 70,
          backgroundColor: Colors.green[500]),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Semantics(
                  child: const Text('\n       Carregando dados da API...',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  label: 'Carregando dados da API');
            default:
              if (snapshot.hasError) {
                return Semantics(
                    child: const Text('Erro ao carregar os dados da API!',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    label: 'Erro ao carregar os dados da API');
              } else {
                loadCoins(snapshot.data);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.attach_money_rounded,
                          size: 120,
                        ),
                        const SizedBox(height: 40),
                        Semantics(
                            child: Text('Selecione a Criptomoeda:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0)),
                            label: 'Escolha uma Criptomoeda'),
                        select(),
                        const SizedBox(height: 30),
                        Semantics(
                            child: Text('Criptomoeda:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 3.0)),
                            label: 'Criptomoeda escolhida'),
                        showValue(selectController),
                        //const SizedBox(height: 5),
                        Semantics(
                            child: Text('Valor da Criptomoeda em R\$:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 3.0)),
                            label: 'Valor da Criptomoeda em reais'),
                        showValue('BRL'),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

// BOX PARA DIGITAR OS VALORES
  Widget showValuesInField(TextEditingController idMoeda, String prefix,
      Function(String) resultado) {
    return TextField(
      controller: idMoeda,
      onChanged: resultado,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45, width: 1.0),
        ),
        prefixText: prefix,
      ),
      style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

// SELEÇÃO DA CRIPTOMOEDA
  Widget select() {
    return DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
      value: selectController,
      onChanged: (String? newValue) {
        setState(() => (selectController = newValue!));
      },
      items: coins.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }

  /* Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  } */

// SET PARA DEFINIR O VALOR QUE COMEÇA NO TEXTFIELD
  void _erase() {
    btcController.text = 1.toStringAsFixed(6);
    ltcController.text = 1.toStringAsFixed(6);
    adaController.text = 1.toStringAsFixed(6);
    uniController.text = 1.toStringAsFixed(6);
    usdcController.text = 1.toStringAsFixed(6);
  }

  Widget showValue(String coin) {
    _erase();

// VALIDAÇÃO NA ESCOLHA DAS CRITOMOEDAS
    if (coin == 'BRL') {
      return showValuesInField(brlController, 'BRL ', _realChanged);
    } else {
      if (selectController == 'BTC') {
        return showValuesInField(btcController, 'BTC ', btcChanged);
      } else if (selectController == 'LTC') {
        return showValuesInField(ltcController, 'LTC ', ltcChanged);
      } else if (selectController == 'ADA') {
        return showValuesInField(adaController, 'ADA ', atcChanged);
      } else if (selectController == 'UNI') {
        return showValuesInField(uniController, 'UNI ', uniChanged);
      } else if (selectController == 'USDC') {
        return showValuesInField(usdcController, 'USDC ', usdcChanged);
      } else {
        return Semantics(
            child: const Text('Erro! Tente novamente!'),
            label: 'Erro Tente novamente');
      }
    }
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double brl = double.parse(text);
    if (selectController == 'BTC') {
      btcController.text = findCotation(btc, 1, brl).toStringAsFixed(6);
    } else if (selectController == 'LTC') {
      ltcController.text = findCotation(ltc, 1, brl).toStringAsFixed(6);
    } else if (selectController == 'ADA') {
      adaController.text = findCotation(ada, 1, brl).toStringAsFixed(6);
    } else if (selectController == 'UNI') {
      uniController.text = findCotation(uni, 1, brl).toStringAsFixed(6);
    } else if (selectController == 'USDC') {
      usdcController.text = findCotation(usdc, 1, brl).toStringAsFixed(6);
    }
  }

  void loadCoins(data) {
    btc = double.parse(data![0].ticker.buy);
    ltc = double.parse(data![1].ticker.buy);
    ada = double.parse(data![2].ticker.buy);
    uni = double.parse(data![3].ticker.buy);
    usdc = double.parse(data![4].ticker.buy);

    if (selectController == 'BTC') {
      brlController.text = btc.toStringAsFixed(2);
    } else if (selectController == 'LTC') {
      brlController.text = ltc.toStringAsFixed(2);
    } else if (selectController == 'ADA') {
      brlController.text = ada.toStringAsFixed(2);
    } else if (selectController == 'UNI') {
      brlController.text = uni.toStringAsFixed(2);
    } else if (selectController == 'USDC') {
      brlController.text = usdc.toStringAsFixed(2);
    }
  }

  void btcChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double coin = double.parse(text);
    brlController.text = findCotation(1, btc, coin).toStringAsFixed(2);
  }

  void ltcChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double coin = double.parse(text);
    brlController.text = findCotation(1, ltc, coin).toStringAsFixed(2);
  }

  void atcChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double coin = double.parse(text);
    brlController.text = findCotation(1, ada, coin).toStringAsFixed(2);
  }

  void uniChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double coin = double.parse(text);
    brlController.text = findCotation(1, uni, coin).toStringAsFixed(2);
  }

  void usdcChanged(String text) {
    if (text.isEmpty) {
      _erase();
      return;
    }
    double coin = double.parse(text);
    brlController.text = findCotation(1, usdc, coin).toStringAsFixed(2);
  }

  // FLUSHBAR
  /* void showTopSnackBar(BuildContext context) => show(
        context,
        Flushbar(
          icon: Icon(
            Icons.error,
            size: 40,
            color: Colors.red,
          ),
          shouldIconPulse: false,
          title: titleSnackBar,
          message: massageSnackBar,
          onTap: (_) {
            print('Clicked bar');
          },
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
        ),
      );

  Future show(BuildContext context, Flushbar newFlushBar) async {
    await Future.wait(flushBars.map((flushBar) => flushBar.dismiss()).toList());
    flushBars.clear();

    newFlushBar.show(context);
    flushBars.add(newFlushBar);
  }

 */
}
