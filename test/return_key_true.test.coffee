vows = require 'vows'
assert = require 'assert'
TinyTotalizer = require '../lib/tiny-totalizer'

vows.describe('return key (true) test')
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
.export module
