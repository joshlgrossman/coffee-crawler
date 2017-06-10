{promisify} = require 'util'
request = promisify require 'request'
cheerio = require 'cheerio'

DOMAIN = /^http[^\.]*((www\.)|(\/\/))([a-zA-Z\-0-9_]{3,})\..*/g
DOMAINS = []

find = ({body}) ->
  $ = cheerio.load(body)
  urls = []
  for a in $('a')
    href = $(a).attr('href')
    if not DOMAIN.test(href) and href not in urls then urls.push href
  return urls

filter = (domain, urls) ->
  urls.filter (url) ->
    DOMAIN.test(url) and url.indexOf(domain) is -1

analyze = (depth, urls) ->
  if depth <= 0 or not urls.length then return
  _analyze = analyze.bind(null, depth - 1)
  for url in urls
    _domain = url.replace(DOMAIN,'$4')
    if _domain not in DOMAINS
      console.log "#{_domain}@#{depth}"
      DOMAINS.push(_domain)
      _filter = filter.bind(null, _domain)
      request(url)
        .then find
        .then _filter
        .then _analyze
        .catch console.log
  return urls

do ->
  args = depth: 3
  for arg in process.argv[2..]
    [key, value] = arg.split('=')
    args[key] = value
  analyze(args.depth, [args.url]) if args.url?
