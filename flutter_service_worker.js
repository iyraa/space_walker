'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "59503a2c5626e22e856da4f8d1ca3657",
"version.json": "96619e8ef944ee622a6aa064d8141250",
"index.html": "f4d9ffbf911acdaf86d7cb7a4f1eefab",
"/": "f4d9ffbf911acdaf86d7cb7a4f1eefab",
"main.dart.js": "5f64836ae607adbb79c4f8a2f9356bc8",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "0574b7f34bcac9307ef6b8b72eb5da1e",
"assets/AssetManifest.json": "1e897329c975ca168a7b1f328c813f98",
"assets/NOTICES": "687b25e51ecbf9ab5b00330bdec250df",
"assets/FontManifest.json": "1926a7c3ab0f7e95dd330630134ea57e",
"assets/AssetManifest.bin.json": "b4f1bb2311347de1fe7e84d3a2257d73",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "20a7ff663cdee0fc8197dd99db277538",
"assets/fonts/Rajdhani-Medium.ttf": "5500ef6a4e84d3be9971dbb138c010e5",
"assets/fonts/Electrolize-Regular.ttf": "69e280e4cae4876c7276c252e9f0aaee",
"assets/fonts/SpaceMono-Regular.ttf": "59c83e1fe244568db558bab69755a6dd",
"assets/fonts/Rajdhani-Light.ttf": "e38f518cff0715ced49fb47f86c71d8a",
"assets/fonts/SpaceMono-Italic.ttf": "c3032fccd961d5b63025241eb1dae029",
"assets/fonts/Rajdhani-Bold.ttf": "62eb2a35acdf719d19b2598e8e5f69df",
"assets/fonts/SpaceMono-Bold.ttf": "87357b7223ab3ed8c3da24f77f51d85f",
"assets/fonts/BrunoAceSC-Regular.ttf": "a2b06d6a2166d7c00cfe79693fa6cfbd",
"assets/fonts/MaterialIcons-Regular.otf": "8fda4bceaceaf51e45998a5af6e18081",
"assets/fonts/Rajdhani-Regular.ttf": "06b5e336b0842925676af9cb04dffe43",
"assets/assets/background/bridge.jpg": "730e5ee7f534da4439ee2100d7db63c2",
"assets/assets/background/first_fragment_2.jpg": "617955d7854fb8b49a84d238f7150af0",
"assets/assets/background/first_fragment_1.jpg": "58bcf19a78343940c789c61ce07a5294",
"assets/assets/background/earth.jpg": "e8d90a1617283cc6b25f659c3324ed5c",
"assets/assets/background/title.gif": "51517ace1a65fef36f30fcbde9211db3",
"assets/assets/background/caelus_prime.jpg": "39f0498d6a7e5c62a657e2d4e8fb8e64",
"assets/assets/background/aida.gif": "765123342f76225179f6b92ba8b9e214",
"assets/assets/background/outpost_theta.jpg": "3924ae7db289afcd6b974dbea01e4120",
"assets/assets/background/control_room.jpg": "44e6b57d726175243450f322b29b9ffd",
"assets/assets/background/memory_chamber.jpg": "c659614b6729f7566d0ce8a8ca6fcd47",
"assets/assets/audio/music/diandra_faye_niviro_orphic_night.mp3": "511f9f46303911833119fcf3a32c5bce",
"assets/assets/audio/music/warriyo_laura_brehm_mortals.mp3": "795f99677f45fe21b1c2db1c0185773a",
"assets/assets/audio/music/anna_yvette_lost_sky_carry_on.mp3": "71514869f4e976c607ef394d9f843d87",
"assets/assets/audio/music/max_brhon_AI.mp3": "caadc99e4bfc4401802915a4c8fd2df5",
"assets/assets/audio/music/jim_yosef_samurai.mp3": "b7be0e63ded6360e2b6d637a6f428c39",
"assets/assets/audio/music/slow_bgm.mp3": "3a3259cdf1f350951c451e0d8f57616d",
"assets/assets/audio/music/anna_yvette_lost_sky_carry_on_vocal.mp3": "96362906585f8835ec9ad62a50592a2c",
"assets/assets/audio/music/32stitches_olympus.mp3": "dfe3387cf845432e8298847216bcc54d",
"assets/assets/audio/sfx/siren.mp3": "d30bd063d742cfcb10b847b07c8a35b4",
"assets/assets/audio/sfx/frequency_loop.mp3": "fa6ce08083f93e7379cf364da4498d09",
"assets/assets/audio/sfx/click.mp3": "3b61f2a050186bad61ca4ce6120799e3",
"assets/assets/audio/sfx/not_real.mp3": "798cc334ab52ce530a3be22a82ac47a3",
"assets/assets/audio/sfx/welcome_captain.mp3": "ef82b4a88b67944bfc684cb62b553c40",
"assets/assets/audio/sfx/scifi_bgm.mp3": "88f1a528e69357b8081fd7006b290487",
"assets/assets/audio/sfx/ghost_in_machine.mp3": "16bc08803c2e37fa0460416167d1cdbd",
"assets/assets/audio/sfx/pin.mp3": "487c2ca35a95560003ddd7abc1f99595",
"assets/assets/json/spacewalker.json": "a3b9c7858f2437303192ce3c6f3270bb",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
