vows = require 'vows'
assert = require 'assert'
TinyTotalizer = require '../lib/tiny-totalizer'

vows.describe('return key (false) test')
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
.export module
