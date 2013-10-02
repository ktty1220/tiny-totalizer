// Generated by CoffeeScript 1.6.3
var TinyTotalizer, assert, vows,
  _this = this;

vows = require('vows');

assert = require('assert');

TinyTotalizer = require('../lib/tiny-totalizer');

vows.describe('return key (true) test').addBatch({
  'コンストラクタ: calcReturnIsKey: true': {
    topic: function() {
      var tt;
      tt = new TinyTotalizer({
        fuzzyLevel: 1,
        calcReturnIsKey: true
      });
      tt.add('aaa');
      return tt.add('AAA');
    },
    'addの戻り値はセットしたキーの統一後のキー名': function(topic) {
      return assert.equal(topic, 'aaa');
    }
  }
})["export"](module);
