const fs = require('fs');

const all_prefs = {};

global.user_pref = function(name, value) {
  if (name == "_user.js.parrot") return;
  all_prefs[name] = value;
}

require(process.cwd() + '/user.js');

fs.writeFileSync('user.json', JSON.stringify(all_prefs), 'utf-8');
