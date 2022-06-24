
import 'package:flutter/material.dart';

enum LanguageType{ENGLISH, ARABIC}

const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String LANGUAGE_LOCAL_PATH = 'assets/translations';

const Locale ENGLISH_LOCAL = Locale('en','US');
const Locale ARABIC_LOCAL = Locale('ar','SA');


extension LanguageTypeExtension on LanguageType{
 String getValue(){
   switch(this) {
     case LanguageType.ENGLISH:
      return ENGLISH;
     case LanguageType.ARABIC:
       return ARABIC;
   }
 }

}