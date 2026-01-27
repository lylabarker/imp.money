const fs = require('fs');
const path = require('path');

// Languages configuration
const languages = {
  es: 'Español',
  ar: 'العربية',
  hi: 'हिन्दी',
  de: 'Deutsch',
  zh: '中文',
  th: 'ไทย',
  pt: 'Português',
  id: 'Bahasa Indonesia',
  ms: 'Bahasa Melayu',
  tr: 'Türkçe',
  vi: 'Tiếng Việt'
};

// Directory structure to create
const directories = [
  'getting-started',
  'yield',
  'referrals',
  'leadership',
  'contracts',
  'faq',
  'resources'
];

// Files to create in each directory (from English originals)
const fileStructure = {
  'getting-started': [
    'what-is-imp-money.md',
    'three-ways-to-earn.md',
    'connect-wallet.md',
    'first-deposit.md',
    'claiming-profits.md',
    'withdrawing.md',
    'bscscan-withdrawal.md'
  ],
  'yield': [
    'how-roi-works.md',
    'pancakeswap-clmm.md',
    'cycles.md',
    'calculator.md'
  ],
  'referrals': [
    'overview.md',
    'commission-rates.md',
    'unlocking-levels.md',
    'referral-link.md',
    'team-building-guide.md'
  ],
  'leadership': [
    '8-rank-system.md',
    'requirements.md',
    'differential-bonus.md',
    'master-king.md'
  ],
  'contracts': [
    'addresses.md',
    'architecture.md',
    'security.md',
    'renounced.md'
  ],
  'faq': [
    'general.md',
    'deposits-withdrawals.md',
    'referrals.md',
    'troubleshooting.md'
  ],
  'resources': [
    'whitepaper.md',
    'brand-assets.md',
    'community.md'
  ]
};

// Create directories
function createDirectories() {
  for (const lang of Object.keys(languages)) {
    for (const dir of directories) {
      const dirPath = path.join(__dirname, lang, dir);
      if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
        console.log(`Created: ${lang}/${dir}/`);
      }
    }
  }
}

// Copy English files to each language directory
function copyFiles() {
  for (const lang of Object.keys(languages)) {
    for (const [dir, files] of Object.entries(fileStructure)) {
      for (const file of files) {
        const sourcePath = path.join(__dirname, dir, file);
        const destPath = path.join(__dirname, lang, dir, file);
        
        // Skip if destination already exists
        if (fs.existsSync(destPath)) {
          console.log(`Skipped (exists): ${lang}/${dir}/${file}`);
          continue;
        }
        
        // Copy from English source if it exists
        if (fs.existsSync(sourcePath)) {
          let content = fs.readFileSync(sourcePath, 'utf8');
          
          // Add translation notice at top
          const langName = languages[lang];
          const notice = `<!-- ${langName} Translation - Review and translate from English original -->\n\n`;
          
          fs.writeFileSync(destPath, notice + content);
          console.log(`Created: ${lang}/${dir}/${file}`);
        } else {
          console.log(`Source not found: ${dir}/${file}`);
        }
      }
    }
  }
}

// Update SUMMARY.md for 7/8-rank-system reference
function fixSummaryReferences() {
  for (const lang of Object.keys(languages)) {
    const summaryPath = path.join(__dirname, lang, 'SUMMARY.md');
    if (fs.existsSync(summaryPath)) {
      let content = fs.readFileSync(summaryPath, 'utf8');
      // Fix 7-rank to 8-rank-system reference
      content = content.replace(/leadership\/7-rank-system\.md/g, 'leadership/8-rank-system.md');
      fs.writeFileSync(summaryPath, content);
      console.log(`Fixed SUMMARY.md references: ${lang}`);
    }
  }
}

console.log('Creating language directories...\n');
createDirectories();

console.log('\nCopying English content to languages...\n');
copyFiles();

console.log('\nFixing SUMMARY.md references...\n');
fixSummaryReferences();

console.log('\n✅ Done! All language files created.');
console.log('📝 Files marked with translation notice - please review and translate.');
