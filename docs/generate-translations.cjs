const fs = require('fs');
const path = require('path');

// Languages to generate
const languages = {
  es: { name: 'Español', dir: 'ltr' },
  ar: { name: 'العربية', dir: 'rtl' },
  hi: { name: 'हिन्दी', dir: 'ltr' },
  de: { name: 'Deutsch', dir: 'ltr' },
  zh: { name: '中文', dir: 'ltr' },
  th: { name: 'ไทย', dir: 'ltr' },
  ms: { name: 'Bahasa Melayu', dir: 'ltr' },
  pt: { name: 'Português', dir: 'ltr' },
  id: { name: 'Bahasa Indonesia', dir: 'ltr' },
  tr: { name: 'Türkçe', dir: 'ltr' },
  vi: { name: 'Tiếng Việt', dir: 'ltr' },
  fr: { name: 'Français', dir: 'ltr' },
  ko: { name: '한국어', dir: 'ltr' },
  ru: { name: 'Русский', dir: 'ltr' }
};

// Translations for each language
const translations = {
  es: {
    // Main
    welcome: 'Bienvenido a IMP Money',
    description: 'IMP Money es un protocolo DeFi descentralizado en BNB Smart Chain',
    keyFeatures: 'Características Principales',
    dailyROI: '0.7% ROI Diario',
    dailyROIDesc: 'Gana rendimientos diarios consistentes en tus depósitos USDT',
    referralSystem: 'Sistema de Referidos de 21 Niveles',
    referralDesc: 'Construye una red y gana 14% en comisiones totales',
    leadershipBonus: 'Bono de Liderazgo de 7 Rangos',
    leadershipDesc: 'Los mejores líderes ganan % adicional en el ROI de su red',
    certikAudited: 'Auditado por CertiK',
    certikDesc: 'Contratos inteligentes verificados por firma de seguridad líder',
    nonCustodial: 'Sin Custodia',
    nonCustodialDesc: 'Tú controlas tus fondos a través de tu propia billetera',
    ukRegistered: 'Registrado en UK',
    ukRegisteredDesc: 'IMP MONEY LTD (Número de Empresa: 16926268)',
    quickStats: 'Estadísticas Rápidas',
    metric: 'Métrica',
    value: 'Valor',
    lockPeriod: 'Período de Bloqueo',
    days: 'días',
    minDeposit: 'Depósito Mínimo',
    totalCommission: 'Comisión Total de Referidos',
    referralLevels: 'Niveles de Referido',
    leadershipRanks: 'Rangos de Liderazgo',
    howItWorks: 'Cómo Funciona',
    depositUSDT: 'Deposita USDT',
    depositDesc: 'Conecta tu billetera y deposita USDT',
    fundsDeployed: 'Fondos Desplegados',
    fundsDesc: 'Capital añadido a pools PancakeSwap V3 CLMM',
    earnDaily: 'Gana Diariamente',
    earnDesc: 'Recibe 0.7% de retornos diarios (reclamables en cualquier momento)',
    withdraw: 'Retira',
    withdrawDesc: 'Después de 21 días, retira tu capital completo + ganancias',
    links: 'Enlaces',
    website: 'Sitio Web',
    telegram: 'Telegram',
    audit: 'Auditoría CertiK',
    viewContracts: 'Ver Contratos',
    disclaimer: 'Aviso Legal',
    disclaimerText: 'Las inversiones en criptomonedas conllevan riesgo. El rendimiento pasado no garantiza resultados futuros. Solo invierte lo que puedas permitirte perder.',
    // Navigation
    tableOfContents: 'Tabla de Contenidos',
    gettingStarted: 'Primeros Pasos',
    whatIsImp: '¿Qué es IMP Money?',
    threeWays: '3 Formas de Ganar',
    connectWallet: 'Cómo Conectar la Billetera',
    firstDeposit: 'Tu Primer Depósito',
    claimingProfits: 'Reclamar Ganancias',
    withdrawingCapital: 'Retirar Capital',
    offlineWithdrawal: 'Retiro Offline (BSCScan)',
    yieldSystem: 'Sistema de Rendimiento',
    howROIWorks: 'Cómo Funciona el ROI',
    pancakeswap: 'PancakeSwap V3 CLMM',
    cycles: 'Ciclos de 21 Días',
    calculator: 'Calculadora de Rendimiento',
    referralProgram: 'Programa de Referidos',
    systemOverview: 'Sistema de 21 Niveles',
    commissionRates: 'Tasas de Comisión',
    unlockingLevels: 'Desbloquear Niveles',
    getReferralLink: 'Obtener tu Enlace',
    teamBuilding: 'Guía de Construcción de Equipo',
    leadershipProgram: 'Programa de Liderazgo',
    rankSystem: 'Sistema de 7 Rangos',
    rankRequirements: 'Requisitos de Rango',
    differentialBonus: 'Bono Diferencial',
    masterKing: 'Rango Master King',
    smartContracts: 'Contratos Inteligentes',
    contractAddresses: 'Direcciones de Contratos',
    architecture: 'Arquitectura',
    security: 'Seguridad y Auditorías',
    renounced: 'Propiedad Renunciada',
    faq: 'Preguntas Frecuentes',
    generalQuestions: 'Preguntas Generales',
    depositsWithdrawals: 'Depósitos y Retiros',
    referralsCommissions: 'Referidos y Comisiones',
    troubleshooting: 'Solución de Problemas',
    resources: 'Recursos',
    whitepaper: 'Whitepaper',
    brandAssets: 'Recursos de Marca',
    community: 'Comunidad'
  },
  de: {
    welcome: 'Willkommen bei IMP Money',
    description: 'IMP Money ist ein dezentrales DeFi-Yield-Protokoll auf BNB Smart Chain',
    keyFeatures: 'Hauptmerkmale',
    dailyROI: '0,7% Tägliche Rendite',
    dailyROIDesc: 'Verdienen Sie konstante tägliche Renditen auf Ihre USDT-Einlagen',
    referralSystem: '21-Stufen-Empfehlungssystem',
    referralDesc: 'Bauen Sie ein Netzwerk auf und verdienen Sie 14% Gesamtprovision',
    leadershipBonus: '7-Rang-Führungsbonus',
    leadershipDesc: 'Top-Leader verdienen zusätzliche % auf die ROI ihrer Downline',
    certikAudited: 'CertiK-geprüft',
    certikDesc: 'Smart Contracts von führender Sicherheitsfirma verifiziert',
    nonCustodial: 'Nicht-verwahrt',
    nonCustodialDesc: 'Sie kontrollieren Ihre Gelder über Ihre eigene Wallet',
    ukRegistered: 'UK-registriert',
    ukRegisteredDesc: 'IMP MONEY LTD (Firmennummer: 16926268)',
    quickStats: 'Schnellübersicht',
    metric: 'Kennzahl',
    value: 'Wert',
    lockPeriod: 'Sperrfrist',
    days: 'Tage',
    minDeposit: 'Mindesteinlage',
    totalCommission: 'Gesamte Empfehlungsprovision',
    referralLevels: 'Empfehlungsebenen',
    leadershipRanks: 'Führungsränge',
    howItWorks: 'So funktioniert es',
    depositUSDT: 'USDT einzahlen',
    depositDesc: 'Verbinden Sie Ihre Wallet und zahlen Sie USDT ein',
    fundsDeployed: 'Mittel eingesetzt',
    fundsDesc: 'Kapital zu PancakeSwap V3 CLMM-Pools hinzugefügt',
    earnDaily: 'Täglich verdienen',
    earnDesc: 'Erhalten Sie 0,7% tägliche Rendite (jederzeit abrufbar)',
    withdraw: 'Abheben',
    withdrawDesc: 'Nach 21 Tagen Ihr gesamtes Kapital + Gewinne abheben',
    tableOfContents: 'Inhaltsverzeichnis',
    gettingStarted: 'Erste Schritte',
    whatIsImp: 'Was ist IMP Money?',
    threeWays: '3 Wege zu verdienen',
    connectWallet: 'Wallet verbinden',
    firstDeposit: 'Erste Einzahlung',
    claimingProfits: 'Gewinne abrufen',
    withdrawingCapital: 'Kapital abheben',
    yieldSystem: 'Rendite-System',
    referralProgram: 'Empfehlungsprogramm',
    leadershipProgram: 'Führungsprogramm',
    smartContracts: 'Smart Contracts',
    faq: 'Häufige Fragen',
    resources: 'Ressourcen'
  },
  zh: {
    welcome: '欢迎来到 IMP Money',
    description: 'IMP Money 是一个建立在 BNB Smart Chain 上的去中心化 DeFi 收益协议',
    keyFeatures: '主要特点',
    dailyROI: '0.7% 日收益',
    dailyROIDesc: '在您的 USDT 存款上获得稳定的每日回报',
    referralSystem: '21级推荐系统',
    referralDesc: '建立网络，赚取14%总佣金',
    leadershipBonus: '7级领导奖金',
    leadershipDesc: '顶级领导者在下线ROI上赚取额外百分比',
    certikAudited: 'CertiK审计',
    certikDesc: '智能合约经领先安全公司验证',
    nonCustodial: '非托管',
    nonCustodialDesc: '您通过自己的钱包控制资金',
    ukRegistered: '英国注册',
    ukRegisteredDesc: 'IMP MONEY LTD (公司编号: 16926268)',
    quickStats: '快速统计',
    metric: '指标',
    value: '值',
    lockPeriod: '锁定期',
    days: '天',
    minDeposit: '最低存款',
    totalCommission: '总推荐佣金',
    referralLevels: '推荐级别',
    leadershipRanks: '领导等级',
    howItWorks: '运作方式',
    depositUSDT: '存入USDT',
    depositDesc: '连接钱包并存入USDT',
    fundsDeployed: '资金部署',
    fundsDesc: '资金添加到 PancakeSwap V3 CLMM 池',
    earnDaily: '每日收益',
    earnDesc: '获得0.7%日回报（随时可领取）',
    withdraw: '提款',
    withdrawDesc: '21天后，提取全部本金+利润',
    tableOfContents: '目录',
    gettingStarted: '开始使用',
    whatIsImp: '什么是 IMP Money？',
    threeWays: '3种赚钱方式',
    connectWallet: '如何连接钱包',
    firstDeposit: '首次存款',
    claimingProfits: '领取收益',
    withdrawingCapital: '提取本金',
    yieldSystem: '收益系统',
    referralProgram: '推荐计划',
    leadershipProgram: '领导计划',
    smartContracts: '智能合约',
    faq: '常见问题',
    resources: '资源'
  },
  th: {
    welcome: 'ยินดีต้อนรับสู่ IMP Money',
    description: 'IMP Money เป็นโปรโตคอล DeFi แบบกระจายศูนย์บน BNB Smart Chain',
    keyFeatures: 'คุณสมบัติหลัก',
    dailyROI: '0.7% ผลตอบแทนรายวัน',
    dailyROIDesc: 'รับผลตอบแทนรายวันที่สม่ำเสมอจากเงินฝาก USDT ของคุณ',
    referralSystem: 'ระบบแนะนำ 21 ระดับ',
    referralDesc: 'สร้างเครือข่ายและรับค่าคอมมิชชั่นรวม 14%',
    leadershipBonus: 'โบนัสผู้นำ 7 อันดับ',
    leadershipDesc: 'ผู้นำระดับสูงรับ % เพิ่มเติมจาก ROI ของดาวน์ไลน์',
    certikAudited: 'ตรวจสอบโดย CertiK',
    certikDesc: 'สัญญาอัจฉริยะได้รับการยืนยันจากบริษัทความปลอดภัยชั้นนำ',
    nonCustodial: 'ไม่มีการเก็บรักษา',
    nonCustodialDesc: 'คุณควบคุมเงินของคุณผ่านกระเป๋าเงินของคุณเอง',
    ukRegistered: 'จดทะเบียนในสหราชอาณาจักร',
    ukRegisteredDesc: 'IMP MONEY LTD (เลขที่บริษัท: 16926268)',
    quickStats: 'สถิติด่วน',
    tableOfContents: 'สารบัญ',
    gettingStarted: 'เริ่มต้นใช้งาน',
    whatIsImp: 'IMP Money คืออะไร?',
    threeWays: '3 วิธีในการรับรายได้',
    connectWallet: 'วิธีเชื่อมต่อกระเป๋าเงิน',
    firstDeposit: 'การฝากเงินครั้งแรก',
    claimingProfits: 'การเรียกร้องกำไร',
    withdrawingCapital: 'การถอนเงินทุน',
    yieldSystem: 'ระบบผลตอบแทน',
    referralProgram: 'โปรแกรมแนะนำ',
    leadershipProgram: 'โปรแกรมผู้นำ',
    smartContracts: 'สัญญาอัจฉริยะ',
    faq: 'คำถามที่พบบ่อย',
    resources: 'แหล่งข้อมูล'
  },
  pt: {
    welcome: 'Bem-vindo ao IMP Money',
    description: 'IMP Money é um protocolo DeFi descentralizado na BNB Smart Chain',
    keyFeatures: 'Principais Características',
    dailyROI: '0,7% ROI Diário',
    dailyROIDesc: 'Ganhe retornos diários consistentes em seus depósitos USDT',
    referralSystem: 'Sistema de Indicação de 21 Níveis',
    referralDesc: 'Construa uma rede e ganhe 14% de comissões totais',
    leadershipBonus: 'Bônus de Liderança de 7 Níveis',
    leadershipDesc: 'Líderes top ganham % adicional no ROI da downline',
    certikAudited: 'Auditado pela CertiK',
    certikDesc: 'Contratos inteligentes verificados por empresa de segurança líder',
    nonCustodial: 'Não-Custodial',
    nonCustodialDesc: 'Você controla seus fundos através da sua própria carteira',
    ukRegistered: 'Registrado no UK',
    ukRegisteredDesc: 'IMP MONEY LTD (Número da Empresa: 16926268)',
    quickStats: 'Estatísticas Rápidas',
    tableOfContents: 'Índice',
    gettingStarted: 'Primeiros Passos',
    whatIsImp: 'O que é IMP Money?',
    threeWays: '3 Formas de Ganhar',
    connectWallet: 'Como Conectar a Carteira',
    firstDeposit: 'Primeiro Depósito',
    claimingProfits: 'Reivindicar Lucros',
    withdrawingCapital: 'Sacar Capital',
    yieldSystem: 'Sistema de Rendimento',
    referralProgram: 'Programa de Indicação',
    leadershipProgram: 'Programa de Liderança',
    smartContracts: 'Contratos Inteligentes',
    faq: 'Perguntas Frequentes',
    resources: 'Recursos'
  },
  id: {
    welcome: 'Selamat Datang di IMP Money',
    description: 'IMP Money adalah protokol DeFi terdesentralisasi di BNB Smart Chain',
    keyFeatures: 'Fitur Utama',
    dailyROI: 'ROI Harian 0,7%',
    dailyROIDesc: 'Dapatkan pengembalian harian yang konsisten dari deposit USDT Anda',
    referralSystem: 'Sistem Referral 21 Tingkat',
    referralDesc: 'Bangun jaringan dan dapatkan total komisi 14%',
    tableOfContents: 'Daftar Isi',
    gettingStarted: 'Memulai',
    whatIsImp: 'Apa itu IMP Money?',
    referralProgram: 'Program Referral',
    leadershipProgram: 'Program Kepemimpinan',
    smartContracts: 'Kontrak Pintar',
    faq: 'FAQ',
    resources: 'Sumber Daya'
  },
  ms: {
    welcome: 'Selamat Datang ke IMP Money',
    description: 'IMP Money adalah protokol hasil DeFi terdesentralisasi di BNB Smart Chain',
    keyFeatures: 'Ciri-ciri Utama',
    dailyROI: 'ROI Harian 0.7%',
    dailyROIDesc: 'Dapatkan pulangan harian yang konsisten daripada deposit USDT anda',
    referralSystem: 'Sistem Rujukan 21 Tahap',
    referralDesc: 'Bina rangkaian dan dapatkan komisen 14%',
    tableOfContents: 'Jadual Kandungan',
    gettingStarted: 'Bermula',
    whatIsImp: 'Apakah IMP Money?',
    referralProgram: 'Program Rujukan',
    leadershipProgram: 'Program Kepimpinan',
    smartContracts: 'Kontrak Pintar',
    faq: 'Soalan Lazim',
    resources: 'Sumber'
  },
  tr: {
    welcome: 'IMP Money\'ye Hoş Geldiniz',
    description: 'IMP Money, BNB Smart Chain üzerinde merkezi olmayan bir DeFi getiri protokolüdür',
    keyFeatures: 'Ana Özellikler',
    dailyROI: '%0,7 Günlük ROI',
    dailyROIDesc: 'USDT mevduatlarınızdan tutarlı günlük getiriler kazanın',
    referralSystem: '21-Seviyeli Referans Sistemi',
    referralDesc: 'Bir ağ kurun ve toplam %14 komisyon kazanın',
    tableOfContents: 'İçindekiler',
    gettingStarted: 'Başlarken',
    whatIsImp: 'IMP Money Nedir?',
    referralProgram: 'Referans Programı',
    leadershipProgram: 'Liderlik Programı',
    smartContracts: 'Akıllı Sözleşmeler',
    faq: 'SSS',
    resources: 'Kaynaklar'
  },
  vi: {
    welcome: 'Chào mừng đến với IMP Money',
    description: 'IMP Money là một giao thức DeFi phi tập trung trên BNB Smart Chain',
    keyFeatures: 'Tính năng chính',
    dailyROI: 'ROI hàng ngày 0,7%',
    dailyROIDesc: 'Kiếm lợi nhuận hàng ngày ổn định từ tiền gửi USDT của bạn',
    referralSystem: 'Hệ thống giới thiệu 21 cấp',
    referralDesc: 'Xây dựng mạng lưới và kiếm 14% tổng hoa hồng',
    tableOfContents: 'Mục lục',
    gettingStarted: 'Bắt đầu',
    whatIsImp: 'IMP Money là gì?',
    referralProgram: 'Chương trình giới thiệu',
    leadershipProgram: 'Chương trình lãnh đạo',
    smartContracts: 'Hợp đồng thông minh',
    faq: 'Câu hỏi thường gặp',
    resources: 'Tài nguyên'
  },
  ar: {
    welcome: 'مرحباً بك في IMP Money',
    description: 'IMP Money هو بروتوكول DeFi لامركزي على BNB Smart Chain',
    keyFeatures: 'الميزات الرئيسية',
    dailyROI: '0.7% عائد يومي',
    dailyROIDesc: 'احصل على عوائد يومية ثابتة على ودائع USDT الخاصة بك',
    referralSystem: 'نظام إحالة من 21 مستوى',
    referralDesc: 'ابنِ شبكة واكسب 14% إجمالي عمولات',
    tableOfContents: 'جدول المحتويات',
    gettingStarted: 'البداية',
    whatIsImp: 'ما هو IMP Money؟',
    referralProgram: 'برنامج الإحالة',
    leadershipProgram: 'برنامج القيادة',
    smartContracts: 'العقود الذكية',
    faq: 'الأسئلة الشائعة',
    resources: 'الموارد'
  },
  hi: {
    welcome: 'IMP Money में आपका स्वागत है',
    description: 'IMP Money BNB Smart Chain पर एक विकेंद्रीकृत DeFi यील्ड प्रोटोकॉल है',
    keyFeatures: 'मुख्य विशेषताएं',
    dailyROI: '0.7% दैनिक ROI',
    dailyROIDesc: 'अपने USDT जमा पर लगातार दैनिक रिटर्न अर्जित करें',
    referralSystem: '21-स्तरीय रेफरल सिस्टम',
    referralDesc: 'नेटवर्क बनाएं और 14% कुल कमीशन कमाएं',
    tableOfContents: 'विषय सूची',
    gettingStarted: 'शुरुआत करें',
    whatIsImp: 'IMP Money क्या है?',
    referralProgram: 'रेफरल प्रोग्राम',
    leadershipProgram: 'लीडरशिप प्रोग्राम',
    smartContracts: 'स्मार्ट कॉन्ट्रैक्ट',
    faq: 'अक्सर पूछे जाने वाले प्रश्न',
    resources: 'संसाधन'
  },
  fr: {
    welcome: 'Bienvenue sur IMP Money',
    description: 'IMP Money est un protocole DeFi décentralisé sur BNB Smart Chain',
    keyFeatures: 'Caractéristiques Principales',
    dailyROI: '0,7% ROI Quotidien',
    dailyROIDesc: 'Gagnez des rendements quotidiens constants sur vos dépôts USDT',
    referralSystem: 'Système de Parrainage à 21 Niveaux',
    referralDesc: 'Construisez un réseau et gagnez 14% de commissions totales',
    tableOfContents: 'Table des Matières',
    gettingStarted: 'Commencer',
    whatIsImp: 'Qu\'est-ce que IMP Money ?',
    referralProgram: 'Programme de Parrainage',
    leadershipProgram: 'Programme de Leadership',
    smartContracts: 'Contrats Intelligents',
    faq: 'FAQ',
    resources: 'Ressources'
  },
  ko: {
    welcome: 'IMP Money에 오신 것을 환영합니다',
    description: 'IMP Money는 BNB 스마트 체인의 분산형 DeFi 수익 프로토콜입니다',
    keyFeatures: '주요 기능',
    dailyROI: '0.7% 일일 수익',
    dailyROIDesc: 'USDT 예치금에서 일관된 일일 수익을 얻으세요',
    referralSystem: '21단계 추천 시스템',
    referralDesc: '네트워크를 구축하고 총 14% 커미션을 받으세요',
    tableOfContents: '목차',
    gettingStarted: '시작하기',
    whatIsImp: 'IMP Money란?',
    referralProgram: '추천 프로그램',
    leadershipProgram: '리더십 프로그램',
    smartContracts: '스마트 컨트랙트',
    faq: '자주 묻는 질문',
    resources: '자료'
  },
  ru: {
    welcome: 'Добро пожаловать в IMP Money',
    description: 'IMP Money - децентрализованный DeFi протокол доходности на BNB Smart Chain',
    keyFeatures: 'Ключевые особенности',
    dailyROI: '0,7% Ежедневный доход',
    dailyROIDesc: 'Получайте стабильный ежедневный доход от депозитов USDT',
    referralSystem: '21-уровневая реферальная система',
    referralDesc: 'Создайте сеть и зарабатывайте 14% комиссий',
    tableOfContents: 'Содержание',
    gettingStarted: 'Начало работы',
    whatIsImp: 'Что такое IMP Money?',
    referralProgram: 'Реферальная программа',
    leadershipProgram: 'Программа лидерства',
    smartContracts: 'Смарт-контракты',
    faq: 'Часто задаваемые вопросы',
    resources: 'Ресурсы'
  }
};

// Template for README.md
function generateReadme(lang) {
  const t = translations[lang] || translations.es;
  return `# IMP Money

<figure><img src="../.gitbook/assets/imp-logo.png" alt=""><figcaption><p>Internet Money Protocol</p></figcaption></figure>

## ${t.welcome}

**IMP Money** ${t.description}

### ${t.keyFeatures}

- 🎯 **${t.dailyROI}** - ${t.dailyROIDesc}
- 🔗 **${t.referralSystem}** - ${t.referralDesc}
- 👑 **${t.leadershipBonus || '7-Rank Leadership Bonus'}** - ${t.leadershipDesc || 'Top leaders earn additional % on downline ROI'}
- 🛡️ **${t.certikAudited || 'CertiK Audited'}** - ${t.certikDesc || 'Smart contracts verified by leading security firm'}
- 🔒 **${t.nonCustodial || 'Non-Custodial'}** - ${t.nonCustodialDesc || 'You control your funds via your own wallet'}
- 🏛️ **${t.ukRegistered || 'UK Registered'}** - ${t.ukRegisteredDesc || 'IMP MONEY LTD (Company No: 16926268)'}

### ${t.quickStats || 'Quick Stats'}

| ${t.metric || 'Metric'} | ${t.value || 'Value'} |
|---------|-------|
| ${t.dailyROI || 'Daily ROI'} | 0.7% |
| ${t.lockPeriod || 'Lock Period'} | 21 ${t.days || 'days'} |
| ${t.minDeposit || 'Minimum Deposit'} | $10 USDT |
| ${t.totalCommission || 'Total Referral Commission'} | 14% |
| ${t.referralLevels || 'Referral Levels'} | 21 |
| ${t.leadershipRanks || 'Leadership Ranks'} | 7 |

### ${t.howItWorks || 'How It Works'}

1. **${t.depositUSDT || 'Deposit USDT'}** - ${t.depositDesc || 'Connect your wallet and deposit USDT'}
2. **${t.fundsDeployed || 'Funds Deployed'}** - ${t.fundsDesc || 'Capital added to PancakeSwap V3 CLMM pools'}
3. **${t.earnDaily || 'Earn Daily'}** - ${t.earnDesc || 'Receive 0.7% daily returns (claimable anytime)'}
4. **${t.withdraw || 'Withdraw'}** - ${t.withdrawDesc || 'After 21 days, withdraw your full capital + profits'}

### ${t.links || 'Links'}

- 🌐 **${t.website || 'Website'}**: [imp.money](https://imp.money)
- 📱 **Telegram**: [t.me/impmoneychat](https://t.me/impmoneychat)
- 🛡️ **${t.audit || 'CertiK Audit'}**: [skynet.certik.com/projects/imp-money](https://skynet.certik.com/projects/imp-money)
- 📊 **BSCScan**: [${t.viewContracts || 'View Contracts'}](https://bscscan.com/address/0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C)

---

> **${t.disclaimer || 'Disclaimer'}**: ${t.disclaimerText || 'Cryptocurrency investments carry risk. Past performance does not guarantee future results. Only invest what you can afford to lose.'}
`;
}

// Template for SUMMARY.md
function generateSummary(lang) {
  const t = translations[lang] || translations.es;
  return `# ${t.tableOfContents}

* [IMP Money](README.md)

## ${t.gettingStarted}

* [${t.whatIsImp}](getting-started/what-is-imp-money.md)
* [${t.threeWays || '3 Ways to Earn'}](getting-started/three-ways-to-earn.md)
* [${t.connectWallet || 'Connect Wallet'}](getting-started/connect-wallet.md)
* [${t.firstDeposit || 'First Deposit'}](getting-started/first-deposit.md)
* [${t.claimingProfits || 'Claiming Profits'}](getting-started/claiming-profits.md)
* [${t.withdrawingCapital || 'Withdrawing Capital'}](getting-started/withdrawing.md)

## ${t.yieldSystem || 'Yield System'}

* [${t.howROIWorks || 'How ROI Works'}](yield/how-roi-works.md)
* [PancakeSwap V3 CLMM](yield/pancakeswap-clmm.md)
* [${t.cycles || '21-Day Cycles'}](yield/cycles.md)

## ${t.referralProgram}

* [${t.systemOverview || '21-Level System'}](referrals/overview.md)
* [${t.commissionRates || 'Commission Rates'}](referrals/commission-rates.md)
* [${t.unlockingLevels || 'Unlocking Levels'}](referrals/unlocking-levels.md)
* [${t.getReferralLink || 'Get Your Link'}](referrals/referral-link.md)

## ${t.leadershipProgram}

* [${t.rankSystem || '7-Rank System'}](leadership/7-rank-system.md)
* [${t.rankRequirements || 'Rank Requirements'}](leadership/requirements.md)
* [${t.differentialBonus || 'Differential Bonus'}](leadership/differential-bonus.md)

## ${t.smartContracts}

* [${t.contractAddresses || 'Contract Addresses'}](contracts/addresses.md)
* [${t.security || 'Security & Audits'}](contracts/security.md)

## ${t.faq}

* [${t.generalQuestions || 'General Questions'}](faq/general.md)
* [${t.depositsWithdrawals || 'Deposits & Withdrawals'}](faq/deposits-withdrawals.md)

## ${t.resources}

* [Whitepaper](resources/whitepaper.md)
* [${t.community || 'Community'}](resources/community.md)
`;
}

// Create directory structure and files for each language
function generateLanguageFiles() {
  for (const [lang, config] of Object.entries(languages)) {
    const langDir = path.join(__dirname, lang);
    
    // Create directories
    const dirs = ['getting-started', 'yield', 'referrals', 'leadership', 'contracts', 'faq', 'resources'];
    dirs.forEach(dir => {
      const fullPath = path.join(langDir, dir);
      if (!fs.existsSync(fullPath)) {
        fs.mkdirSync(fullPath, { recursive: true });
      }
    });
    
    // Generate README.md
    fs.writeFileSync(path.join(langDir, 'README.md'), generateReadme(lang));
    
    // Generate SUMMARY.md
    fs.writeFileSync(path.join(langDir, 'SUMMARY.md'), generateSummary(lang));
    
    console.log(`Generated ${lang} (${config.name}) structure`);
  }
}

// Copy and template all English files for each language
function copyEnglishTemplates() {
  const englishDir = __dirname;
  const englishFiles = [];
  
  // Get all English markdown files
  function walkDir(dir, prefix = '') {
    const files = fs.readdirSync(dir);
    files.forEach(file => {
      const fullPath = path.join(dir, file);
      const relativePath = path.join(prefix, file);
      if (fs.statSync(fullPath).isDirectory() && !Object.keys(languages).includes(file)) {
        walkDir(fullPath, relativePath);
      } else if (file.endsWith('.md') && !['README.md', 'SUMMARY.md'].includes(file)) {
        englishFiles.push(relativePath);
      }
    });
  }
  
  walkDir(englishDir);
  
  // Copy files to each language directory
  for (const lang of Object.keys(languages)) {
    const langDir = path.join(__dirname, lang);
    
    englishFiles.forEach(relPath => {
      const srcPath = path.join(englishDir, relPath);
      const destPath = path.join(langDir, relPath);
      const destDir = path.dirname(destPath);
      
      // Skip if source doesn't exist or is in a language directory
      if (!fs.existsSync(srcPath) || relPath.startsWith('es/') || relPath.startsWith('ar/') || relPath.startsWith('hi/')) {
        return;
      }
      
      // Create directory if needed
      if (!fs.existsSync(destDir)) {
        fs.mkdirSync(destDir, { recursive: true });
      }
      
      // Copy file if it doesn't exist in target
      if (!fs.existsSync(destPath)) {
        const content = fs.readFileSync(srcPath, 'utf8');
        fs.writeFileSync(destPath, content);
        console.log(`Copied ${relPath} to ${lang}/`);
      }
    });
  }
}

// Run the generation
console.log('Generating language files...\n');
generateLanguageFiles();
console.log('\nCopying English templates...\n');
copyEnglishTemplates();
console.log('\nDone! Files generated for all languages.');
console.log('\nNOTE: The copied English files should be translated manually or via a translation service.');
