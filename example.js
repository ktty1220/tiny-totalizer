#!/usr/bin/env node

var TinyTotalizer = require('./lib/tiny-totalizer');

var tt1 = new TinyTotalizer({
  allowMinus: false,  // 0未満にはならない
  fuzzyLevel: 1       // 曖昧さ統一レベル(0～2)
}, {
  // 集計用初期データ
  javascript: 2,
  c: 2,
  cpp: 5,
  perl: 3,
  ruby: 0,
  php: 3,
  python: 4, 
  shellscript: 1
});

tt1.add('c');             // 'c'にカウント +1
tt1.sub('ruby', 2);       // 'ruby'のカウント -3
tt1.sub('coffeescript');  // 'coffeescript'を新規に追加(allowMinusがfalseなので0以下にはならず0が入る)
tt1.add('typescript', 5); // 'typescript'を新規に追加(カウントは5)
tt1.sub('JavaScript');    // 曖昧さ統一レベルが1なので大文字小文字を同一と扱い'javascript'にカウント -1
tt1.add('shell script');  // 曖昧さ統一レベルが1なので空白の有無は別扱いで'shell script'を新規に追加

// 集計結果出力(降順)
console.log('### ranking 1\n', tt1.ranking({
  border: 2,  // 集計結果表示対象とする必要カウント(最低2以上のカウントが必要)
  topN: 5     // TOP5まで表示
}));

var tt2 = new TinyTotalizer({
  allowMinus: true,             // 0未満になる
  standardizer: function (s) {  // キー統一関数を指定
    // 空白とハイフン、アンダーバーを除去する
    return s.toLowerCase().replace(/[\s\-_]/g, '');
  }
}, {
  shellscript: 2
});

tt2.sub('coffeescript');  // 'coffeescript'を新規に追加(allowMinusがtrueなので-1が入る)
tt2.add('coffee-script'); // 曖昧さ統一レベルが3なので'coffeescript'に +1
tt2.add('shell_script');  // 曖昧さ統一レベルが3なので'shellscript'に +1 

// 集計結果出力(昇順)
console.log('### ranking 2\n', tt2.ranking({asc: true}));
