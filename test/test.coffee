vows = require 'vows'
assert = require 'assert'
TinyTotalizer = require '../lib/tiny-totalizer'

vows.describe('tt test')
.addBatch
  'コンストラクタ: 引数なし':
    topic: () -> new TinyTotalizer()
    '内部ハッシュが空': (topic) =>
      assert.deepEqual topic.hash, {}
    'デフォルトオプションがセットされている': (topic) =>
      assert.isTrue topic.opt.allowMinus
      assert.isZero topic.opt.fuzzyLevel
.addBatch
  'コンストラクタ: 初期データのハッシュの値が数値以外':
    topic: () ->
      new TinyTotalizer {},
        aaa: null
        bbb: 'two'
        ccc: '3'
        ddd: [ 1, 2, 3 ]
        eee: new Error 'error'
    '数値化できない値は登録されていない': (topic) =>
      assert.deepEqual topic.hash, ccc: 3
.addBatch
  'コンストラクタ: allowMinus = false':
    topic: () ->
      tt = new TinyTotalizer allowMinus: false, { aaa: -1, bbb: 0, ccc: 1 }
      tt.sub 'bbb'
      tt
    '初期で0未満の値は0になっている & sub()で0未満になっていない': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 0
        bbb: 0
        ccc: 1
.addBatch
  'コンストラクタ: fuzzyLevel = 0(省略値)':
    topic: () ->
      tt = new TinyTotalizer {}, aaa: 0
      tt.add 'aaa'
      tt.add 'AAA'
      tt.add 'a a a'
      tt
    'すべて別キーでカウントされている': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 1
        AAA: 1
        'a a a': 1
.addBatch
  'コンストラクタ: fuzzyLevel = 1':
    topic: () ->
      tt = new TinyTotalizer fuzzyLevel: 1
      tt.add 'aaa'
      tt.add 'AAA'
      tt.add 'a a a'
      tt
    '大文字小文字が同一として扱われている': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 2
        'a a a': 1
.addBatch
  'コンストラクタ: fuzzyLevel = 2':
    topic: () ->
      tt = new TinyTotalizer fuzzyLevel: 2
      tt.add 'aaa'
      tt.add 'AAA'
      tt.add 'a a a'
      tt
    'すべて同一キーとして扱われている': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 3
.addBatch
  'コンストラクタ: fuzzyLevel = 3':
    topic: () -> new TinyTotalizer fuzzyLevel: 3
    '存在しないレベルなのでエラーが発生する': (topic) =>
      assert.throws () => topic.add 'aaa'
.addBatch
  'コンストラクタ: standardizer指定':
    topic: () ->
      tt = new TinyTotalizer
        fuzzyLevel: 0
        standardizer: (s) -> s.toLowerCase().replace /[\s\-]/g, ''
      tt.add 'aaa'
      tt.add 'AAA'
      tt.add 'a a a'
      tt.add '-a a a-'
      tt
    'fuzzyLevelが3になっている': (topic) =>
      assert.equal topic.opt.fuzzyLevel, 3
    'standardizerで指定した関数でキーの統一化がされる': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 4
.addBatch
  'コンストラクタ: calcReturnIsKey無指定':
    topic: () ->
      tt = new TinyTotalizer
        fuzzyLevel: 1
      tt.add 'aaa'
      tt.add 'AAA'
    'addの戻り値はセットしたキーのカウント数': (topic) =>
      assert.equal topic, 2
.addBatch
  'コンストラクタ: calcReturnIsKey: false':
    topic: () ->
      tt = new TinyTotalizer
        fuzzyLevel: 1
        calcReturnIsKey: false
      tt.add 'aaa'
      tt.add 'AAA'
    'addの戻り値はセットしたキーのカウント数': (topic) =>
      assert.equal topic, 2
.addBatch
  'コンストラクタ: calcReturnIsKey: true':
    topic: () ->
      tt = new TinyTotalizer
        fuzzyLevel: 1
        calcReturnIsKey: true
      tt.add 'aaa'
      tt.add 'AAA'
    'addの戻り値はセットしたキーの統一後のキー名': (topic) =>
      assert.equal topic, 'aaa'
.addBatch
  'add: 正常な値':
    topic: () ->
      tt = new TinyTotalizer {}, aaa: 1
      tt.add 'aaa'
      tt.add 'aaa', 1
      tt.add 'aaa', 2
      tt.add 'aaa', 3
      tt.add 'aaa', -1
      tt
    '計算結果が正しい': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 7
.addBatch
  'add: 数値以外':
    topic: () ->
      tt = new TinyTotalizer {}, aaa: 1
      tt.add 'aaa', 'two'
      tt.add 'aaa', '3'
      tt.add 'aaa', ' 4 '
      tt.add 'aaa', [ 1, 2, 3 ]
      tt.add 'aaa', new Error 'error'
      tt
    '数値化できるもののみ加算されている': (topic) =>
      assert.deepEqual topic.hash,
        aaa: 8
.addBatch
  'sub: 正常な値':
    topic: () ->
      tt = new TinyTotalizer {}, aaa: 1
      tt.sub 'aaa'
      tt.sub 'aaa', 1
      tt.sub 'aaa', 2
      tt.sub 'aaa', 3
      tt.sub 'aaa', -1
      tt
    '計算結果が正しい': (topic) =>
      assert.deepEqual topic.hash,
        aaa: -5
.addBatch
  'sub: 数値以外':
    topic: () ->
      tt = new TinyTotalizer {}, aaa: 1
      tt.sub 'aaa', 'two'
      tt.sub 'aaa', '3'
      tt.sub 'aaa', ' 4 '
      tt.sub 'aaa', [ 1, 2, 3 ]
      tt.sub 'aaa', new Error 'error'
      tt
    '数値化できるもののみ減算されている': (topic) =>
      assert.deepEqual topic.hash,
        aaa: -6
.addBatch
  'ranking':
    topic: () -> new TinyTotalizer {},
        aaa: 1
        bbb: 2
        ccc: 3
        ddd: 4
        eee: 5
        fff: 6
        ggg: 7
        hhh: 8
    '引数なし': (topic) =>
      assert.deepEqual topic.ranking(), [
        { name: 'hhh', count: 8 }
        { name: 'ggg', count: 7 }
        { name: 'fff', count: 6 }
        { name: 'eee', count: 5 }
        { name: 'ddd', count: 4 }
        { name: 'ccc', count: 3 }
        { name: 'bbb', count: 2 }
        { name: 'aaa', count: 1 }
      ]
    'border指定': (topic) =>
      assert.deepEqual topic.ranking(border: 5), [
        { name: 'hhh', count: 8 }
        { name: 'ggg', count: 7 }
        { name: 'fff', count: 6 }
        { name: 'eee', count: 5 }
      ]
    'border指定(対象がすべてborder以下)': (topic) =>
      assert.deepEqual topic.ranking(border: 100), []
    'topN指定': (topic) =>
      assert.deepEqual topic.ranking(topN: 3), [
        { name: 'hhh', count: 8 }
        { name: 'ggg', count: 7 }
        { name: 'fff', count: 6 }
      ]
    'asc指定': (topic) =>
      assert.deepEqual topic.ranking(asc: true), [
        { name: 'aaa', count: 1 }
        { name: 'bbb', count: 2 }
        { name: 'ccc', count: 3 }
        { name: 'ddd', count: 4 }
        { name: 'eee', count: 5 }
        { name: 'fff', count: 6 }
        { name: 'ggg', count: 7 }
        { name: 'hhh', count: 8 }
      ]
    '複合': (topic) =>
      assert.deepEqual topic.ranking(border: 5, topN: 3, asc: true), [
        { name: 'eee', count: 5 }
        { name: 'fff', count: 6 }
        { name: 'ggg', count: 7 }
      ]
.export module
