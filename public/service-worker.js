/**
 * Created by miki on 2016-06-06.
 */
var cacheName = 'elemental-search';
var filesToCache = [
    '/',
    '/styles/style.css',
    '/scripts/app.js'
];

self.addEventListener('install', function(e) {
    console.log('service worker installed');
    e.waitUntil(caches.open(cacheName).then(function(cache){
        console.log('cached app shell');
        return cache.addAll(filesToCache);
    }));
});

self.addEventListener('activate', function(e) {
    console.log('service worker activated');
    e.waitUntil(
        caches.keys().then(function(keyList) {
            return Promise.all(keyList.map(function(key) {
                if (key !== cacheName) {
                    console.log('service worker removed old cache', key);
                    return caches.delete(key);
                }
            }));
        })
    );
});

self.addEventListener('fetch', function(e) {
    console.log('service worker fetches', e.request.url);
    e.respondWith(
        caches.match(e.request).then(function(response) {
            return response || fetch(e.request);
        })
    );
});