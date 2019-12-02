
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';


class QuesionArr {
  static const family = [["A1", "Utilizator elementar", "- Pot sa inteleg expresii "
      "cunoscute si propozitii foarte simple referitoare la mine, la familie "
      "si la imprejurari concrete, cand se vorbeste rar si cu claritate."],
    ["A2", "Utilizator elementar", " - Pot sa inteleg expresii si cuvinte uzuale frecvent intalnite pe teme ce au relevanta imediata pentru mine personal (de ex., informatii simple despre mine is familia mea, cumparaturi, zona unde locuiesc, activitatea profesionala). Pot sa inteleg punctele esentiale din anunturi si mesaje scurte, simple si clare "],
    ["B1", "Utilizator independent", " - Pot să înţeleg punctele esenţiale în vorbirea standard clară pe teme familiare referitoare la activitatea profesională, scoală, petrecerea timpului liber etc. Pot să înţeleg ideea principală din multe programe radio sau TV pe teme de actualitate sau de interes personal sau profesional, dacă sunt prezentate într-o manieră relativ clară şi lentă."],
    ["B2", "Utilizator independent", " - Pot să înţeleg conferinţe şi discursuri destul de lungi şi să urmăresc chiar şi o argumentare complexă, dacă subiectul îmi este relativ cunoscut. Pot să înţeleg majoritatea emisiunilor TV de ştiri şi a programelor de actualităţi. Pot să înţeleg majoritatea filmelor în limbaj standard. "],
    ["C1", "Utilizator independent", " - Pot să înţeleg conferinţe şi discursuri destul de lungi şi să urmăresc chiar şi o argumentare complexă, dacă subiectul îmi este relativ cunoscut. Pot să înţeleg majoritatea emisiunilor TV de ştiri şi a programelor de actualităţi. Pot să înţeleg majoritatea filmelor în limbaj standard. "],
    ["C2", "Utilizator independent", " - Nu am nici o dificultate în a înţelege limba vorbită, indiferent dacă este vorba despre comunicarea directă sau în transmisiuni radio, sau TV, chiar dacă ritmul este cel rapid al vorbitorilor nativi, cu condiţia de a avea timp să mă familiarizez cu un anumit accent."]];

  static const family1 = [["Utilizator elementar", "- Pot căuta informaţii onlinefolosind un motor de căutare. Ştiu că nu toateAlte limbi straine cunoscute informaţiile online sunt verosimile. Pot salva saustoca fişiere sau conţinut (ex. text, imagini, muzică,video, pagini web) şi le pot regăsi odată salvate Alte limbi straine cunoscutesau stocate."],
    [ "Utilizator independent", "- Pot folosi diferite motoare Intelegerede căutare pentru a găsi informaţii. Folosesc anumite filtre atunci când caut (ex. caută numai C2 | Utilizator experimentat - Nu am nici o dificu...imagini, video, hărţi). Compar diferitele surse Cpietinretru a verifica veridicitatea informaţiilor găsite.Grupez informaţia într-o manieră metodicăC2 | Utilizator experimentat - Pot sa citesc cu us...folosind fişiere şi foldere pentru a le găsi mai uşor.Realizez copii de siguranţă (backup) pentru Vorbireinformaţiile sau fişierele stocate."],
    [ "Utilizator experimenta", " - Pot utiliza tehnici Discurs oral complexe de căutare (ex. operatori de căutare) pentru a găsi informaţii fiabile pe internet. Pot C2 | Utilizator experimentat - Pot sa prezint o de...utiliza feed-uri web (de ex. RSS) pentru a fi la Sccurriernet cu lucrurile de interes pentru mine. Potfolosind un set de criterii. Sunt la curent cu noile progrese în ceea ce priveşte căutarea de informaţii, stocarea şi regăsirea acestora. Pot salva informaţia găAsditaăupgeainatltearnliemt bînadsitfreariintea formate. Pot folosi servicii de tip cloud pentru depozitarea informaţiei."],
  ];
}


class questionWidget
{
  static  Widget Dialogview()
  {
    return  Container
      (color: Colors.white,
      padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
      alignment: Alignment.center,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: QuesionArr.family.length,
        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pop(true);

            },
            child:  FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text(
                      QuesionArr.family[index][0],
                      style:
                      TextStyle(color: Appcolor.redHeader, fontSize: 16.0, fontFamily: 'regular')
                  ),
                  SizedBox(width: 10,),
                  aVerticalLine,
                  SizedBox(width: 4,),
                  Flexible(
                    child:  RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text:  QuesionArr.family[index][1], style:
                          TextStyle(color: Appcolor.redHeader, fontSize: 16.0, fontFamily: 'dami')),
                          TextSpan(text:  QuesionArr.family[index][2],style:
                          TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'regular')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}

