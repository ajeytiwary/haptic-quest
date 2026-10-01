const C="hq-v3";
const A=["./","index.html","styles.css","app.js","festival.js","manifest.json"];
self.addEventListener("install",e=>e.waitUntil(caches.open(C).then(c=>c.addAll(A))));
self.addEventListener("activate",e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==C).map(k=>caches.delete(k))))));
self.addEventListener("fetch",e=>{
  if(e.request.method!=="GET") return;
  e.respondWith(
    caches.match(e.request).then(cached=>{
      if(cached) return cached;
      return fetch(e.request).then(res=>{
        if(new URL(e.request.url).origin===location.origin){
          const copy=res.clone();
          caches.open(C).then(c=>c.put(e.request,copy));
        }
        return res;
      }).catch(()=>caches.match("index.html"));
    })
  );
});