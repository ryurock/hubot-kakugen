# Description:
#   Hubot-scripts Returns meigenDB feed information from http://systemincome.com/
#
# Commands:
#   hubot 格言 - http://systemincome.com/から格言をランダムに取得します
#   hubot 格言 チームワーク - http://systemincome.com/から格言(チームワーク)をランダムに取得します
#   hubot 格言 仕事 - http://systemincome.com/から格言(仕事)をランダムに取得します
#   hubot 格言 ライフ - http://systemincome.com/から格言(ライフ)をランダムに取得します
#   hubot 格言 コミュニケーション - http://systemincome.com/から格言(コミュニケーション)をランダムに取得します
#

request = require 'request'
cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /(格|名)言$/i, (msg) ->
    genre = ['チームワーク', 'ライフ','仕事','コミュニケーション']
    rand = msg.random genre
    kakugenMe robot, msg, rand

  robot.respond /(格|名)言( me)? (チームワーク|ライフ|仕事|コミュニケーション)(.*)/i, (msg) ->
    kakugenMe robot, msg, msg.match[3]

kakugenMe = (robot, msg, keywords) ->

  if keywords.match(/チームワーク/)
    url = 'http://systemincome.com/main/kakugen/category/team'
  if keywords.match(/ライフ/)
    url = 'http://systemincome.com/main/kakugen/category/life'
  if keywords.match(/仕事/)
    url = 'http://systemincome.com/main/kakugen/category/cat649'
  if keywords.match(/コミュニケーション/)
    url = 'http://systemincome.com/main/kakugen/category/人間関係・コミュニケーション'

  options =
    url      : url
    timeout  : 2000
    headers  : {'user-agent': 'node title fetcher'}

  request options, (error, response, body) ->
    data = []
    $ = cheerio.load body
    lastNum = $('#catego').find('blockquote').length
    $('#catego').find('blockquote').each((i, elem) ->
      text = "【#{robot.name}】が#{keywords}に関する名言・格言をしゃき〜〜んと発言するだじょー\n\n"
      text = text + "#{$(this).text()}\n\n#{$(this).find('a').attr('href')}\n\n-------------------\n\n"
      data.push(text)
      if (lastNum - 1) == i
        msg.send msg.random data
    )
