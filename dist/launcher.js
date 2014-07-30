console.log("Launcher Up. Waiting for config payload.");

self.onmessage = function(e) {
  var opts;
  opts = e.data;
  importScripts(opts.sea_url);
  if (opts.sea_opts != null) {
    seajs.config(opts.sea_opts);
  }
  return seajs.use(opts.worker_url);
};
