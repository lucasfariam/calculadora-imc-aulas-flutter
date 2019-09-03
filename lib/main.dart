import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Pessoa {
  TextEditingController peso;
  TextEditingController altura;
  String nome;
  bool gender;
  Color cor;
  String resultNumber; 
  String resultText; 
  

  calcularImc (){
    double heigth = double.parse(altura.text) / 100.0;
    double imc = double.parse(peso.text) / (heigth * heigth);
    return imc;
  }
  
  verificaTabelaImc( imc, gender ) {
    this.resultNumber = "IMC = ${imc.toStringAsPrecision(2)}\n";
    if (gender) {
      if (imc <= 20.7) {
        this.resultText = "Abaixo do peso";
        cor = Colors.red[400].withOpacity(0.8);
      }
      else if (imc < 26.4) {
        this.resultText = "Peso ideal";
        cor = Colors.blue.withOpacity(0.8);
      }
      else if (imc < 27.8) {
        this.resultText = "Pouco acima do peso";
        cor = Colors.red[200].withOpacity(0.8);
      }
      else if (imc < 31.1) {
        this.resultText = "Acima do peso";
        cor = Colors.red[300].withOpacity(0.8);
      }
      else {
        this.resultText = "Obesidade";
        cor = Colors.red.withOpacity(0.8);
      }
    } else {
      if (imc < 19.1) {
        this.resultText = "Abaixo do peso";
        cor = Colors.red[400].withOpacity(0.8);
      }
      else if (imc < 25.8) {
        this.resultText = "Peso ideal";
        cor = Colors.blue.withOpacity(0.8);
      }
      else if (imc < 27.3) {
        this.resultText = "Pouco acima do peso";
        cor = Colors.red[200].withOpacity(0.8);
      }
      else if (imc < 32.3) {
        this.resultText = "Acima do peso";
        cor = Colors.red[300].withOpacity(0.8);
      }
      else {
        this.resultText = "Obesidade";
        cor = Colors.red.withOpacity(0.8);
      }
    }
  }
  Pessoa(this.peso, this.altura, this.gender){
    var imcLocal = calcularImc();
    var _gender = this.gender;
    verificaTabelaImc(imcLocal, _gender);
  }
}


class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _resultNumber = ''; 
  String _resultText = '';
  bool isSwitched = false;
  Color colorText;
  String textGender = 'Feminino';


  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _resultText = 'Informe seus dados';
    });
  }

  void calculateImc() {
    Pessoa pessoa = Pessoa(_weightController, _heightController, isSwitched);
    var imc = pessoa.calcularImc();

  
    setState(() {
      pessoa.verificaTabelaImc(imc, isSwitched);
      _resultNumber = pessoa.resultNumber;
      _resultText = pessoa.resultText;
      colorText = pessoa.cor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              resetFields();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                controller: _weightController,
                validator: (text) {
                  return text.isEmpty ? "Insira seu peso!" : null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Altura (cm)'),
                controller: _heightController,
                validator: (text) {
                  return text.isEmpty ? "Insira sua altura!" : null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Container (
                  child: Row(children: <Widget>[
                    Checkbox(
                    value: isSwitched,
                    onChanged: (bool value) {
                        setState(() {
                            isSwitched = value;
                            if (value) textGender = 'Masculino';
                            else textGender = 'Feminino';
                        });
                      }
                    ),
                    Text(textGender),
                  ],)
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.0),
                child: Container (
                  child: Column(children: <Widget>[
                    Text(
                      _resultNumber, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorText,
                        fontSize: 50
                      ),
                    ),
                    Text(
                      _resultText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorText,
                        fontSize: 20
                      ),
                    )
                  ],),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 36.0),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        calculateImc();
                      }
                    },
                    child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
                  )
                )
              ),
            ]
          )
        )
      )
    );
  }
}
