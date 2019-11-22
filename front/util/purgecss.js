const isHotReloaded = process.argv.includes('serve');
const postcss = require('postcss');

class TailwindExtractor {
  static extract(content) {
    return content.match(/[A-Za-z0-9-_:\/]+/g) || [];
  }
}

let config = {
  content: ['./public/index.html', './src/**/*.vue'],
  extractors: [
    {
      extractor: TailwindExtractor,
      extensions: ['html', 'vue', 'js'],
    },
  ],
};

module.exports = postcss.plugin('tailwind-purgecss', function(opts) {
  if (isHotReloaded) return () => {};
  const purgecss = require('@fullhuman/postcss-purgecss');
  let cfg = Object.assign(config, opts);
  if (cfg.whitelistPatternsChildren) {
  	cfg.whitelistPatternsChildren = cfg.whitelistPatternsChildren.map( x => new RegExp(x));
  }
  if (cfg.whitelistPatterns) {
  	cfg.whitelistPatterns = cfg.whitelistPatterns.map( x => new RegExp(x));
  }
  return purgecss(cfg);
});
