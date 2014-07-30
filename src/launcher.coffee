# IE doesn't support inline worker from blob and there's no plan to fix it
# http://connect.microsoft.com/IE/feedback/details/801810/web-workers-from-blob-urls-in-ie-10-and-11
# Has to be launched from script file
console.log "Launcher Up. Waiting for config payload."
self.onmessage = (e) ->
  opts = e.data
  importScripts opts.sea_url
  if opts.sea_opts?
    seajs.config opts.sea_opts
  seajs.use opts.worker_url
