const apiBenchmark = require('api-benchmark');
const fs = require('fs');

const service = {
  server1: 'http://localhost:9999/rest/rest/',
//   server1: 'http://localhost:8887/rest/rest/',
//   server2: 'http://localhost:8888/rest/rest/',
//   server3: 'http://localhost:8889/rest/rest/',
};


const form = {name: 'file', buffer: fs.createReadStream('test.pdf'), fileName: 'test.pdf'};

const routes = { route1: {
    method: 'post',
    route: 'docs',
    formData: form
  }};

apiBenchmark.measure(service, routes, {runMode: 'parallel', stopOnError: false, minSamples: 300}, function(err, results) {
  console.log(err);
    console.log(results);
  // displays some stats!
  apiBenchmark.getHtml(results, function(error, html) {
    fs.writeFileSync('result.html', html, {encoding: 'utf8'});
    // now save it yourself to a file and enjoy
  });
});
