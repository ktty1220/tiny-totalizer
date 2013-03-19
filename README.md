# TinyTotalizer - 連想配列を使用したNode.js用簡易集計モジュール

連想配列のキーに該当したらカウントを加算するような簡易集計を行う場合、連想配列ならではの問題点に遭遇します。

1. キーが大文字小文字含めて完全一致しないといけない
2. カウントを加算する前にキーが存在するかチェックする必要がある

TinyTotalizerはそういった問題を気にせずに簡易集計をすることを目的として作られたモジュールですが、その他にもランキング表示などの簡易集計を便利に行う機能を含んでいます。

## サンプル

### sample.js

    var TinyTotalizer = require('tiny-totalizer');

    var tt = new TinyTotalizer({ fuzzyLevel: 2 });
    tt.add('javascript');
    tt.add('JavaScript');
    tt.add('coffeeScript', 3);
    tt.add('coffee script', 2);
    tt.sub('JAVASCRIPT');
      ・
      ・
      ・
    console.log(tt.ranking({ topN: 10 }));

    /* console.log()の出力
    [
      { name: 'coffeeScript', count: 5 },
      { name: 'javascript', count: 1 },
        ・
        ・
        ・
    ]
    */

`TinyTotalizer`オブジェクトを作成し、そのオブジェクトに対して`add`および`sub`メソッドでキーに該当するカウントを加減算し、最後に`ranking`メソッドで集計結果のランキング配列を取得する流れになっています。

## インストール

    npm install tiny-totalizer

## 使用方法

    var TinyTotalizer = require('tiny-totalizer');

で、TinyTotalizerモジュールをロードします。ロードした変数`TinyTotalizer`を`new`でインスタンス化したオブジェクトで集計を行います。

### メソッド

#### コンストラクタ new([options, initialData])

TinyTotalizerオブジェクトを作成します。

##### 第一引数: options (省略可能)

連想配列で指定します。指定できるオプションは以下の通りです。

* allowMinus (`true`/`false`, デフォルト: `true`)

    減算により、対象キーのカウントが0未満になる事を許可するかどうかの指定です。

    `false`にすると、対象キーのカウントから0未満になるような減算を行ってもカウントは0になります。

* fuzzyLevel (数値, デフォルト: `0`)

    キーの一致判定に関しての曖昧さレベルです。数値で指定します。

    * `0`: 大文字・小文字も含めて完全に一致するキーのカウントを加減算します。該当するキーがなければ新規にカウント0でキーを作成します。

    * `1`: 大文字・小文字の違いを無視した上で一致するキーのカウントを加減算します。キーの形は元から存在する方です。

    * `2`: 大文字・小文字の違いと半角スペースの有無を無視した上で一致するキーのカウントを加減算します。

* standardizer (関数)

    上記`fuzzyLevel`で用意されている以外のキーの文字統一を行いたい場合に、独自の文字統一関数を登録できます。

    引数で受け取った文字列を加工して返す関数を指定します。

        function customStandardizer (s) {
          // キーを比較する時に、比較する側・される側どちらもこの処理を施してから比較を行う。
          // この例では小文字に統一して、半角スペースとハイフンを除去したキーで比較する。
          return s.toLowerCase().replace(/[\s\-]/g, '');
        });
        var tt = new TinyTotalizer({ standardizer: customStandardizer });  // 文字統一関数を独自のものに変更
        tt.add('javascript');
        tt.add('Java-Script'); // 'javascript'と同一とみなされ、'javascript'キーに加算される

    `standardizer`を指定した場合は`fuzzyLevel`の指定は無視されます。

##### 第二引数: initialData (省略可能) 

オブジェクト作成時点でセットする初期集計データです。

{ キー: カウント }の連想配列を指定します。

カウントが数値化できない値(配列やオブジェクト, 数字以外の文字列など)の場合、そのキーは登録されません。

#### add(key [, count]);

`key`のカウントを加算します。`count`を省略した場合は1を加算します。

負数を指定した場合は減算されます。

`count`が数値化できない値(配列やオブジェクト, 数字以外の文字列など)の場合、加算も減算も行いません。

#### sub(key [, count]);

`key`のカウントを減算します。`count`を省略した場合は1を減算します。

負数を指定した場合は加算されます。

`count`が数値化できない値(配列やオブジェクト, 数字以外の文字列など)の場合、加算も減算も行いません。

#### ranking([options])

集計オブジェクトで加減算されたキーをランキング化します。

戻り値は{ name: キー名, count: カウント }の配列です。デフォルトではカウントが多い順にソートされた状態で返されます。

引数`options`は連想配列で指定します。指定できるオプションは以下の通りです。

* asc (`true`/`false`, デフォルト: `false`)

    `true`にするとカウントが少ない順にソートしたランキングを返します。

* border (数値, デフォルト: 制限なし)

    集計結果表示対象とする必要カウントを指定します。このオプションを指定すると、指定した数値以上のカウント数があるキーのみでランキングを作成します。

* topN (数値, デフォルト: 制限なし)

    何位までのランキングを作成するかの指定です。例えば10を指定すると、TOP10のランキングを返します。

## Changelog

### 0.1.0 (2013-03-20)

* 初版リリース

## ライセンス

[MIT license](http://www.opensource.org/licenses/mit-license)で配布します。

&copy; 2013 [ktty1220](mailto:ktty1220@gmail.com)
