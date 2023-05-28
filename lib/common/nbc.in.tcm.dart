//中醫九大體質
// Nine Body Constitutions in Tradition Chinese Medicine
class NBCinTCM {
  static List<String> types = [
    '平和型體質',
    '氣虛體質',
    '陽虛體質',
    '陰虛體質',
    '痰濕體質',
    '濕熱體質',
    '血瘀體質',
    '氣鬱體質',
    '特稟體質'
  ];

  static List<List> evaluationForm = [
    //平和型體質
    [
      "您精力充沛嗎？",
      "您容易疲乏嗎？",
      "您說話聲音低弱無力嗎？",
      "您感到悶悶不樂、情緒低沉嗎？ ",
      "您比一般人耐受不了寒冷（冬天的寒冷，夏天的冷空調、電扇等）嗎？",
      "您能適應外界自然和社會環境的變化嗎？",
      "您容易失眠嗎？",
      "您容易忘事（健忘）嗎？",
    ],
    //氣虛體質
    [
      "您容易疲乏嗎？",
      "您容易氣短（呼吸短促，接不上氣）嗎？",
      "您容易心慌嗎？",
      "您容易頭暈或站起時暈眩嗎？",
      "您比別人容易患感冒嗎？",
      "您喜歡安靜、懶得說話嗎？",
      "您說話聲音低弱無力嗎？",
      "您活動量稍大就容易出虛汗嗎？",
    ],
    //陽虛體質
    [
      "您手腳發涼嗎？",
      "您胃部、背部或腰膝部怕冷嗎？",
      "您感到怕冷、衣服比別人穿得多嗎？",
      "您比一般人耐受不了寒冷（冬天的寒冷，夏天的冷空調、電扇等）嗎？",
      "您比別人容易患感冒嗎？",
      "您吃（喝）涼的東西會感到不舒服或者怕吃（喝）涼的東西嗎？",
      "您受涼或吃（喝）涼的東西後，容易腹瀉（拉肚子）嗎？",
    ],
    //陰虛體質
    [
      "您感到腳心發熱嗎？",
      "您感覺身體、臉上發熱嗎？",
      "您皮膚或口唇乾嗎？",
      "您口唇的顏色比別人紅嗎？",
      "您容易便秘或大便乾燥嗎？",
      "您面部兩額潮紅或偏紅嗎？",
      "您感到眼睛乾澀嗎？",
      "您感到口乾咽燥、總想喝水嗎？",
    ],
    //痰濕體質
    [
      "您感到胸悶或腹部脹滿嗎？",
      "您感到身體沉重不輕鬆或不爽快嗎？",
      "您腹部肥滿鬆軟嗎？",
      "您有額部油脂分泌多的現象嗎？",
      "您上眼臉比別人腫（上眼臉有輕微隆起的現象）嗎？",
      "您嘴裏有黏黏的感覺嗎？",
      "您平時痰多，特別是咽喉部總感到有痰堵著嗎？",
      "你舌苔厚膩或有舌苔厚厚的感覺嗎？",
    ],
    //濕熱體質
    [
      "您面部或鼻部有油膩感或者油亮發光嗎？",
      "您易生痤瘡或瘡病嗎？",
      "您感到口苦或嘴裏有異味嗎？",
      "你大便黏滯不爽、有解不盡的感覺嗎？",
      "你小便時尿道有發熱感、尿色濃（深）嗎？",
      {
        "F": "您帶下色黃（白帶顏色發黃）嗎？",
        "M": "您的陰囊部位潮濕嗎？",
      }
    ],
    //血瘀體質
    [
      "您的皮膚在不知不覺中會出現青紫瘀斑（皮下出血）嗎？",
      "您兩顴部有細微紅絲嗎？",
      "您身休上有哪裡疼痛嗎？",
      "您面色晦暗、或容易出現褐斑嗎？",
      "您容易有黑眼圈嗎？",
      "您容易忘事（健忘）嗎？",
      "您口唇顏色偏暗嗎？",
    ],
    //氣鬱體質
    [
      "您感到悶悶不樂、情緒低沉嗎？",
      "您容易精神緊張、焦慮不安嗎？",
      "您多愁善感、感情脆弱嗎？",
      "您容易感到害怕或受到驚嚇嗎？",
      "您脅肋部或乳房脹痛嗎？",
      "您無緣無故嘆氣嗎？",
      "您咽喉部有異物感、且吐之不出、咽之不下嗎？",
    ],
    //特稟體質
    [
      "您不感冒也會打噴嚏嗎？",
      "您不感冒也會鼻塞、流鼻涕嗎？",
      "您有因季節變化、溫度變化或異味等原因而咳喘的現象嗎？",
      "您容易過敏（對藥物、食物、氣味、花粉或在季節交替、氣候變化時）嗎？",
      "您的皮膚容易起蕁麻疹（風團、風疹塊、風疙瘩）嗎？",
      "您的皮膚因過敏出現過紫癜（紫紅色瘀點瘀斑）嗎？",
      "您的皮膚一抓就紅，並出現抓痕嗎？",
    ]
  ];
  static List<String> images = [
    "neutral.png", //0 平和型體質
    "qi_deficient.png", // 1 氣虛體質
    "yang_deficient.png", // 2 陽虛體質
    "yin_deficient.png", // 3 陰虛體質
    "phlegm_dampness.png", // 4 痰濕體質
    "damp_heat.png", // 5 濕熱體質
    "blood_stasis.png", // 6 血瘀體質
    "qi_stagnation.png", // 7 氣鬱體質
    "special_constitution.png", // 8 特稟體質
  ];

  static List<String> titleList = [
    "平和體質",
    "氣虛體質",
    "陽虛體質",
    "陰虛體質",
    "痰濕體質",
    "濕熱體質",
    "血瘀體質",
    "氣鬱體質",
    "特稟體質"
  ];
  static List<String> featureList = [
    // 0 平和型體質
    "體形勻稱健壯，目光有神，唇色紅潤，膚色潤澤，頭髮稠密有光澤，不易疲勞，睡眠良好，精力充沛，耐受寒熱，食欲好，大小便正常，舌色淡紅，苔薄白，脈和緩有力，性格隨和開朗。",
    // 1 氣虛體質
    "肌肉鬆軟不實，説話聲音低弱，氣短，容易疲憊，容易出汗，舌邊有齒痕，容易感冒，內臟下垂等疾病，生病後難以痊癒，不易適應風寒、暑濕環境，性格較為內向。",
    // 2 陽虛體質
    "肌肉不健壯，畏寒、手腳冰冷，精神不振，舌淡胖嫩，脈沉遲，喜歡吃熱食，易浮腫、腹瀉、陽痿等問題，性格沉靜和內向。",
    // 3 陰虛體質
    "體形偏瘦，手足心熱，怕熱，口乾，鼻微乾燥，喜冷飲，大便乾燥，舌紅少津，脈筋細。有虛勞、失精、失眠、咳嗽、乾燥綜合征等毛病。性情急躁，外向好動。",
    // 4 痰濕體質
    "體型肥胖，腹部肥滿鬆軟，汗多且黏，臉部油脂較多，胸悶，痰多，口腔黏膩或甜，喜愛肥甘甜食，舌苔膩，脈滑。易患消渴、中風、胸痹等病。性格偏溫和、穩重，多善，有耐心。",
    // 5 濕熱體質
    "體型中等或偏瘦，身重困倦，面垢油光，易有暗瘡，口苦口臭，排便不暢或便秘，小便黃，男性陰囊潮濕，女性白帶增多，舌質偏紅，苔黃膩，脈滑數。男適應在濕重或高溫環境。性格容易心煩急躁。",
    // 6 血瘀體質
    "體型為胖瘦均有，畏寒，面色晦黯，易有色斑，嘴唇黯淡，舌頭易見瘀紫容易淤青。多有痛証、出血症狀或異常增生。性格容易煩躁，健忘。",
    // 7 氣鬱體質
    "體型偏瘦，神情抑鬱，情緒低沉，容易焦慮不安，多愁善感，煩悶不樂，心慌和失眠，舌淡紅，苔薄白，脈弦。易患有情緒問題、神經衰弱、失眠或乳腺增生等疾病。",
    // 8 特稟體質
    "體型偏瘦，神情抑鬱，情緒低沉，容易焦慮不安，多愁善感，煩悶不樂，心慌和失眠，舌淡紅，苔薄白，脈弦。易患有情緒問題、神經衰弱、失眠或乳腺增生等疾病。",
  ];

  static getType(List scoreList) {
    int tempType = UNDEFINE_TYPE;
    double tempScore = -1;

    // (平和體質外)大於 40 則為該體質
    scoreList.sublist(1).asMap().forEach((index, score) {
      if (score >= 40 && score > tempScore) {
        tempScore = score;
        tempType = index + 1; //因為此foreach 不含第一項平和質，所以索引要補1
      }
    });
    // (平和體質外)分小於40 同時 平和質 大於等於 60 則為 和平體質
    if (tempScore == -1 && scoreList[0] >= 60) {
      tempType = NEUTRAL_TYPE;
    }

    // 上面判別都不成立時，(平和體質外)大於 30 則為該體質
    if (tempType == UNDEFINE_TYPE) {
      scoreList.sublist(1).asMap().forEach((index, score) {
        if (score >= 30 && score > tempScore) {
          tempScore = score;
          tempType = index + 1;
        }
      });
    }
    // 上面判別都不成立時  則為 平和體質
    if (tempType == UNDEFINE_TYPE) {
      tempType = NEUTRAL_TYPE;
    }

    return tempType;
  }

  //中醫九大體質 index

  static int UNDEFINE_TYPE = -1;
  // 平和型體質
  static int NEUTRAL_TYPE = 0;
  // 氣虛體質
  static int QI_DEFICIENT_TYPE = 1;

// 陽虛體質
  final int YANG_DEFICIENT_TYPE = 2;

// 陰虛體質
  final int YIN_DEFICIENT_TYPE = 3;

// 痰濕體質
  static int PHLEGM_DAMPNESS_TYPE = 4;
// 濕熱體質
  static int DAMP_HEAT_TYPE = 5;
// 血瘀體質
  static int BLOOD_STASIS_TYPE = 6;
// 氣鬱體質
  static int QI_STAGNATION_TYPE = 7;
// 特稟體質
  static int SPECIAL_CONSTITUTION_TYPE = 8;
}
