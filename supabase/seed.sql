insert into festivals(id,name,theme,city,starts_at,ends_at,published,config) values
('glow-eindhoven-2026','GLOW Eindhoven 2026','CONNECT','Eindhoven','2026-11-07T17:30:00Z','2026-11-14T22:00:00Z',true,'{"currency":"Light","goal":1000,"prototype":true}'::jsonb)
on conflict(id) do update set name=excluded.name,theme=excluded.theme,city=excluded.city,config=excluded.config;

insert into checkpoints(festival_id,slug,name,place,clue,lat,lon,radius_m,xp,sort_order,published) values
('glow-eindhoven-2026','machina','MACHINA','18 Septemberplein','Find the machine where the city begins to pulse.',51.4416,5.4773,35,150,1,true),
('glow-eindhoven-2026','victoria','Connection Signal','Victoriapark','Follow the pulse west into the park.',51.4412,5.4725,35,150,2,true),
('glow-eindhoven-2026','inline','In-Line v360','Stadhuisplein','Find the monumental signal near city hall.',51.4366,5.4804,35,250,3,true),
('glow-eindhoven-2026','catharina','Hidden Light','Catharinakerk','Seek light beside an old landmark.',51.4378,5.4782,35,200,4,true),
('glow-eindhoven-2026','market','Final Connection','Market Square','Complete the circuit where Eindhoven meets.',51.4392,5.4787,35,250,5,true)
on conflict(festival_id,slug) do update set name=excluded.name,place=excluded.place,clue=excluded.clue,lat=excluded.lat,lon=excluded.lon,radius_m=excluded.radius_m,xp=excluded.xp,sort_order=excluded.sort_order,published=excluded.published;

insert into rewards(festival_id,name,inventory,active)
select 'glow-eindhoven-2026','CONNECT completion reward',500,true
where not exists(select 1 from rewards where festival_id='glow-eindhoven-2026' and name='CONNECT completion reward');
