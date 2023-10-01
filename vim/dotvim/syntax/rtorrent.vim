" Vim Syntax file for rtorrent.rc
" Author: Chris Carpita <ccarpita@gmail.com>
" Version: 0.1
" Revised: May, 2008

if !exists("main_syntax")
	let main_syntax='rtorrent'
endif

syn match rtorrentComment "#.*$"

syn keyword rtorrentSetting min_peers max_peers min_peers_seed max_peers_seed max_uploads download_rate upload_rate directory session schedule ip bind port_range port_random check_hash use_udp_trackers encryption dht dht_port peer_exchange hash_read_ahead hash_interval hash_max_tries d.data_path.set dht.port.set directory.default.set d.session_file.set file.prioritize_toc.first.set file.prioritize_toc.last.set file.prioritize_toc.set group2.seeding.ratio.max.set group2.seeding.ratio.min.set group2.seeding.ratio.upload.set group2.seeding.view.set group.insert_persistent_view.set group.seeding.ratio.command.set group.seeding.ratio.disable.set group.seeding.ratio.enable.set keys.layout.set method.const.enable method.insert method.set_key method.use_deprecated.set method.use_intermediate.set network.port_open.set network.port_random.set network.port_range.set network.scgi.dont_route.set pieces.hash.on_completion.set protocol.choke_heuristics.down.leech.set protocol.choke_heuristics.down.seed.set protocol.choke_heuristics.up.leech.set protocol.choke_heuristics.up.seed.set protocol.connection.leech.set protocol.connection.seed.set protocol.pex.set scheduler.max_active.set session.name.set session.on_completion.set session.use_lock.set system.api_version.set system.client_version.set system.daemon.set system.file.allocate.set system.file.max_size.set system.file.split_size.set system.file.split_suffix.set system.library_version.set system.startup_time.set throttle.max_downloads.div._val.set throttle.max_downloads.global._val.set throttle.max_downloads.set throttle.max_peers.normal.set throttle.max_peers.seed.set throttle.max_uploads.div._val.set throttle.max_uploads.global._val.set throttle.max_uploads.set throttle.min_downloads.set throttle.min_peers.normal.set throttle.min_peers.seed.set throttle.min_uploads.set trackers.numwant.set trackers.use_udp.set ui.throttle.global.step.large.set ui.throttle.global.step.medium.set ui.throttle.global.step.small.set ui.torrent_list.layout.set view.filter.temp.excluded.set view.filter.temp.log.set contained

syn match rtorrentOp "=" contained

syn match rtorrentStatement "\s*\w\+\s*=\s*.*$" contains=rtorrentSettingAttempt,rtorrentOp

syn match rtorrentSettingAttempt "^\s*\w\+" contains=rtorrentSetting contained

if !exists('HiLink') 
	command! -nargs=+ HiLink hi link <args>
endif

HiLink rtorrentSettingAttempt   String
HiLink rtorrentStatement    Type
HiLink rtorrentComment  Comment
HiLink rtorrentSetting  Operator
HiLink rtorrentOp       Special
