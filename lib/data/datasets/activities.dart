import '../models/activity.dart';

class Activities {
  // Purpose tags: 'vacation', 'date_idea', 'school_business'
  // Most activities support multiple purposes so the planner always has results.
  static const List<TravelActivity> all = [
    // ── Manila ────────────────────────────────────────────────
    TravelActivity(id: 'manila_1', destinationId: 'manila', title: 'Intramuros Walking Tour', description: 'Explore Spanish-era walls, Fort Santiago, and San Agustin Church.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🏰', duration: '3–4 hrs'),
    TravelActivity(id: 'manila_2', destinationId: 'manila', title: 'Binondo Food Crawl', description: 'Taste hopia, dumplings, and lumpia in the world\'s oldest Chinatown.', purposeTags: ['vacation', 'date_idea'], emoji: '🥟', duration: '2–3 hrs'),
    TravelActivity(id: 'manila_3', destinationId: 'manila', title: 'BGC Art Walk & Rooftop Dining', description: 'Modern murals, sky-bars, and the city\'s best skyline view.', purposeTags: ['date_idea', 'school_business'], emoji: '🎨', duration: '2–3 hrs'),
    TravelActivity(id: 'manila_4', destinationId: 'manila', title: 'National Museum Complex', description: 'See the Spoliarium and Filipino archaeological treasures — free entry.', purposeTags: ['school_business', 'vacation'], emoji: '🖼️', duration: '3–5 hrs'),

    // ── Baguio ────────────────────────────────────────────────
    TravelActivity(id: 'baguio_1', destinationId: 'baguio', title: 'Burnham Park Boat Ride', description: 'Pedal boats on the lagoon, surrounded by pine trees.', purposeTags: ['vacation', 'date_idea'], emoji: '⛵', duration: '1–2 hrs'),
    TravelActivity(id: 'baguio_2', destinationId: 'baguio', title: 'Session Road Night Market', description: 'Bargain ukay-ukay shopping and street food till midnight.', purposeTags: ['vacation', 'date_idea'], emoji: '🛍️', duration: '2–3 hrs'),
    TravelActivity(id: 'baguio_3', destinationId: 'baguio', title: 'BenCab Museum Visit', description: 'National Artist\'s gallery surrounded by an eco-trail and farm cafe.', purposeTags: ['school_business', 'date_idea'], emoji: '🖼️', duration: '2–3 hrs'),
    TravelActivity(id: 'baguio_4', destinationId: 'baguio', title: 'Strawberry Farm Picking', description: 'La Trinidad farms — pick fresh berries and try strawberry taho.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🍓', duration: '1–2 hrs'),

    // ── Tagaytay ──────────────────────────────────────────────
    TravelActivity(id: 'tagaytay_1', destinationId: 'tagaytay', title: 'Taal Volcano View Lunch', description: 'Hot bulalo overlooking the volcano-in-a-lake panorama.', purposeTags: ['vacation', 'date_idea'], emoji: '🍲', duration: '2 hrs'),
    TravelActivity(id: 'tagaytay_2', destinationId: 'tagaytay', title: 'Sky Ranch Ferris Wheel', description: 'Sky Eye ride with full-rim Taal lake views at sunset.', purposeTags: ['date_idea', 'vacation'], emoji: '🎡', duration: '2–3 hrs'),
    TravelActivity(id: 'tagaytay_3', destinationId: 'tagaytay', title: 'Picnic Grove Zipline', description: 'Cliff-edge picnic areas plus zipline across pine valleys.', purposeTags: ['vacation', 'school_business'], emoji: '🪂', duration: '1–2 hrs'),

    // ── Batangas ──────────────────────────────────────────────
    TravelActivity(id: 'batangas_1', destinationId: 'batangas', title: 'Anilao Diving', description: 'World-class macro diving — nudibranchs, frogfish, blue rings.', purposeTags: ['vacation'], emoji: '🤿', duration: 'Half day'),
    TravelActivity(id: 'batangas_2', destinationId: 'batangas', title: 'Taal Heritage Town Walk', description: 'Ancestral homes, Galleria Taal, and the Basilica.', purposeTags: ['school_business', 'date_idea'], emoji: '🏛️', duration: '3 hrs'),
    TravelActivity(id: 'batangas_3', destinationId: 'batangas', title: 'Laiya Beach Day', description: 'White sand cove, easy waves, and family-style resorts.', purposeTags: ['vacation', 'date_idea'], emoji: '🏖️', duration: 'Full day'),

    // ── Vigan ─────────────────────────────────────────────────
    TravelActivity(id: 'vigan_1', destinationId: 'vigan', title: 'Calle Crisologo Kalesa Ride', description: 'Cobblestone street tour through colonial mansions by horse cart.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🐎', duration: '1 hr'),
    TravelActivity(id: 'vigan_2', destinationId: 'vigan', title: 'Pagburnayan Pottery Workshop', description: 'Try ancient Ilocano clay-jar making with local masters.', purposeTags: ['school_business', 'vacation'], emoji: '🏺', duration: '2 hrs'),
    TravelActivity(id: 'vigan_3', destinationId: 'vigan', title: 'Empanada & Bagnet Tasting', description: 'Crispy Vigan empanadas and crunchy bagnet at Plaza Burgos.', purposeTags: ['date_idea', 'vacation'], emoji: '🥟', duration: '1–2 hrs'),

    // ── Laoag ─────────────────────────────────────────────────
    TravelActivity(id: 'laoag_1', destinationId: 'laoag', title: 'Paoay Sand Dunes 4x4', description: 'Wild sand-dune buggy ride and sandboarding on Pacific dunes.', purposeTags: ['vacation'], emoji: '🏜️', duration: '2–3 hrs'),
    TravelActivity(id: 'laoag_2', destinationId: 'laoag', title: 'Paoay Church Visit', description: 'UNESCO baroque church with massive coral-stone buttresses.', purposeTags: ['school_business', 'date_idea'], emoji: '⛪', duration: '1–2 hrs'),
    TravelActivity(id: 'laoag_3', destinationId: 'laoag', title: 'Kapurpurawan Rock Sunset', description: 'White limestone formations against the West Philippine Sea.', purposeTags: ['date_idea', 'vacation'], emoji: '🌅', duration: '2 hrs'),

    // ── Sagada ────────────────────────────────────────────────
    TravelActivity(id: 'sagada_1', destinationId: 'sagada', title: 'Sumaguing Cave Spelunking', description: 'Wade through limestone chambers led by local guides.', purposeTags: ['vacation'], emoji: '🦇', duration: '3–4 hrs'),
    TravelActivity(id: 'sagada_2', destinationId: 'sagada', title: 'Kiltepan Sunrise Trek', description: 'Sea-of-clouds sunrise from the famous viewpoint.', purposeTags: ['date_idea', 'vacation'], emoji: '🌄', duration: '3 hrs'),
    TravelActivity(id: 'sagada_3', destinationId: 'sagada', title: 'Hanging Coffins Cultural Tour', description: 'Echo Valley walk with stories of Igorot burial traditions.', purposeTags: ['school_business', 'vacation'], emoji: '⚰️', duration: '2 hrs'),

    // ── Angeles ──────────────────────────────────────────────
    TravelActivity(id: 'angeles_1', destinationId: 'angeles', title: 'Aling Lucing Sisig', description: 'The legendary birthplace of sisig, sizzling on a hot plate.', purposeTags: ['date_idea', 'vacation'], emoji: '🍳', duration: '1–2 hrs'),
    TravelActivity(id: 'angeles_2', destinationId: 'angeles', title: 'Clark Hot Air Balloon', description: 'February balloon festival or year-round tethered rides.', purposeTags: ['vacation', 'date_idea'], emoji: '🎈', duration: '2–3 hrs'),
    TravelActivity(id: 'angeles_3', destinationId: 'angeles', title: 'Mt. Pinatubo Crater Trek', description: '4x4 + hike to the legendary turquoise crater lake.', purposeTags: ['vacation', 'school_business'], emoji: '🌋', duration: 'Full day'),

    // ── Subic ─────────────────────────────────────────────────
    TravelActivity(id: 'subic_1', destinationId: 'subic', title: 'Ocean Adventure Park', description: 'Open-water marine park with whale and dolphin shows.', purposeTags: ['vacation', 'school_business'], emoji: '🐬', duration: 'Half day'),
    TravelActivity(id: 'subic_2', destinationId: 'subic', title: 'Tree Top Adventure', description: 'Canopy zipline rides through the rainforest of Subic.', purposeTags: ['vacation', 'date_idea'], emoji: '🌳', duration: '3 hrs'),
    TravelActivity(id: 'subic_3', destinationId: 'subic', title: 'Boardwalk Sunset Stroll', description: 'Bayfront walk with restaurants, pubs, and live music.', purposeTags: ['date_idea', 'vacation'], emoji: '🌇', duration: '2 hrs'),

    // ── Baler ─────────────────────────────────────────────────
    TravelActivity(id: 'baler_1', destinationId: 'baler', title: 'Sabang Beach Surf Lesson', description: 'Beginner-friendly waves with local surf instructors.', purposeTags: ['vacation'], emoji: '🏄', duration: '2 hrs'),
    TravelActivity(id: 'baler_2', destinationId: 'baler', title: 'Ditumabo Mother Falls Hike', description: 'Forest trail to a powerful 50-foot waterfall.', purposeTags: ['vacation', 'date_idea'], emoji: '💦', duration: '3 hrs'),
    TravelActivity(id: 'baler_3', destinationId: 'baler', title: 'Baler Heritage Walk', description: 'Dona Aurora\'s house and the Apocalypse-Now church.', purposeTags: ['school_business', 'date_idea'], emoji: '⛪', duration: '2 hrs'),

    // ── Lucena ────────────────────────────────────────────────
    TravelActivity(id: 'lucena_1', destinationId: 'lucena', title: 'Pahiyas Festival Day Trip', description: 'Lucban\'s harvest festival with rice-art kiping houses (May).', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🌽', duration: 'Full day'),
    TravelActivity(id: 'lucena_2', destinationId: 'lucena', title: 'Kamay ni Hesus Shrine', description: 'Hilltop shrine with 300-step Stations of the Cross climb.', purposeTags: ['school_business', 'date_idea'], emoji: '✝️', duration: '2 hrs'),
    TravelActivity(id: 'lucena_3', destinationId: 'lucena', title: 'Dalahican Seafood Dinner', description: 'Wharf-side grill — fresh tuna, prawns, sizzling pork.', purposeTags: ['date_idea', 'vacation'], emoji: '🍤', duration: '2 hrs'),

    // ── Naga ──────────────────────────────────────────────────
    TravelActivity(id: 'naga_1', destinationId: 'naga', title: 'CWC Wakeboarding', description: 'Cable-pulled wakeboard park — beginner to pro tracks.', purposeTags: ['vacation', 'date_idea'], emoji: '🏄', duration: '3–4 hrs'),
    TravelActivity(id: 'naga_2', destinationId: 'naga', title: 'Peñafrancia Basilica Visit', description: 'Bicol\'s pilgrimage center and devotion center.', purposeTags: ['school_business', 'date_idea'], emoji: '⛪', duration: '1–2 hrs'),
    TravelActivity(id: 'naga_3', destinationId: 'naga', title: 'Bicol Express Cooking', description: 'Spicy coconut-cream pork stew lessons at Bigg\'s.', purposeTags: ['vacation', 'school_business'], emoji: '🌶️', duration: '2 hrs'),

    // ── Legazpi ───────────────────────────────────────────────
    TravelActivity(id: 'legazpi_1', destinationId: 'legazpi', title: 'Mayon ATV Lava Trail', description: 'Quad bike ride across volcanic lava fields.', purposeTags: ['vacation'], emoji: '🏍️', duration: '2–3 hrs'),
    TravelActivity(id: 'legazpi_2', destinationId: 'legazpi', title: 'Cagsawa Ruins Sunset', description: 'Belfry ruins with the perfect Mayon cone backdrop.', purposeTags: ['date_idea', 'school_business'], emoji: '🌋', duration: '2 hrs'),
    TravelActivity(id: 'legazpi_3', destinationId: 'legazpi', title: 'Whale Shark Watch (Donsol)', description: 'Snorkel with butanding in nearby Donsol Bay.', purposeTags: ['vacation', 'school_business'], emoji: '🦈', duration: 'Half day'),

    // ── Puerto Galera ────────────────────────────────────────
    TravelActivity(id: 'puerto_galera_1', destinationId: 'puerto_galera', title: 'White Beach Nightlife', description: 'Beach bars, fire dancers, and laid-back live bands.', purposeTags: ['vacation', 'date_idea'], emoji: '🎸', duration: 'Evening'),
    TravelActivity(id: 'puerto_galera_2', destinationId: 'puerto_galera', title: 'Coral Garden Snorkel', description: 'Banca trip to shallow reefs full of fish.', purposeTags: ['vacation', 'school_business'], emoji: '🐠', duration: '3 hrs'),
    TravelActivity(id: 'puerto_galera_3', destinationId: 'puerto_galera', title: 'Tamaraw Falls Stop', description: 'Roadside cascade — quick swim on the way in.', purposeTags: ['date_idea', 'vacation'], emoji: '💧', duration: '1 hr'),

    // ── Coron ─────────────────────────────────────────────────
    TravelActivity(id: 'coron_1', destinationId: 'coron', title: 'Kayangan Lake Tour', description: 'Cleanest lake in Asia, surrounded by sheer karst cliffs.', purposeTags: ['vacation', 'date_idea'], emoji: '🏞️', duration: 'Full day'),
    TravelActivity(id: 'coron_2', destinationId: 'coron', title: 'Shipwreck Diving', description: 'WWII Japanese shipwrecks at recreational depths.', purposeTags: ['vacation', 'school_business'], emoji: '🛳️', duration: 'Half day'),
    TravelActivity(id: 'coron_3', destinationId: 'coron', title: 'Mt. Tapyas Sunset Climb', description: '700 steps to the giant cross with all-island view.', purposeTags: ['date_idea', 'school_business'], emoji: '⛰️', duration: '2 hrs'),

    // ── El Nido ───────────────────────────────────────────────
    TravelActivity(id: 'el_nido_1', destinationId: 'el_nido', title: 'Tour A — Big & Small Lagoons', description: 'Iconic kayak adventure between sheer karst walls.', purposeTags: ['vacation', 'date_idea'], emoji: '🛶', duration: 'Full day'),
    TravelActivity(id: 'el_nido_2', destinationId: 'el_nido', title: 'Nacpan Beach Day', description: '4 km of golden twin beach — quiet, lazy paradise.', purposeTags: ['vacation', 'date_idea'], emoji: '🌴', duration: 'Half day'),
    TravelActivity(id: 'el_nido_3', destinationId: 'el_nido', title: 'Corong-Corong Sunset', description: 'Beachfront cocktails as the sky goes pink.', purposeTags: ['date_idea', 'vacation'], emoji: '🍸', duration: '2 hrs'),

    // ── Puerto Princesa ──────────────────────────────────────
    TravelActivity(id: 'puerto_princesa_1', destinationId: 'puerto_princesa', title: 'Underground River Tour', description: 'UNESCO subterranean river — 8 km of cathedral caverns.', purposeTags: ['vacation', 'school_business'], emoji: '🦇', duration: 'Full day'),
    TravelActivity(id: 'puerto_princesa_2', destinationId: 'puerto_princesa', title: 'Honda Bay Island Hopping', description: 'Snake, Luli, and Cowrie islands — snorkeling and lunch.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Full day'),
    TravelActivity(id: 'puerto_princesa_3', destinationId: 'puerto_princesa', title: 'Iwahig Firefly Watch', description: 'Mangrove paddleboat under a sky of flickering fireflies.', purposeTags: ['date_idea', 'school_business'], emoji: '✨', duration: '2 hrs'),

    // ── Pagudpud ─────────────────────────────────────────────
    TravelActivity(id: 'pagudpud_1', destinationId: 'pagudpud', title: 'Saud Beach Day', description: 'Long, white, near-empty beach perfect for swimming.', purposeTags: ['vacation', 'date_idea'], emoji: '🏖️', duration: 'Full day'),
    TravelActivity(id: 'pagudpud_2', destinationId: 'pagudpud', title: 'Bangui Windmills Stop', description: 'Iconic seafront wind turbines — unmissable photo op.', purposeTags: ['date_idea', 'school_business'], emoji: '💨', duration: '1 hr'),
    TravelActivity(id: 'pagudpud_3', destinationId: 'pagudpud', title: 'Patapat Viaduct Drive', description: 'Coastal flyover hugging cliffs above the Pacific.', purposeTags: ['vacation', 'date_idea'], emoji: '🚗', duration: '1–2 hrs'),

    // ── Cebu City ────────────────────────────────────────────
    TravelActivity(id: 'cebu_city_1', destinationId: 'cebu_city', title: 'Magellan\'s Cross & Basilica', description: 'Birthplace of Philippine Christianity — Sto. Niño church.', purposeTags: ['school_business', 'date_idea', 'vacation'], emoji: '✝️', duration: '2 hrs'),
    TravelActivity(id: 'cebu_city_2', destinationId: 'cebu_city', title: 'Lechon Belly Lunch', description: 'Crispy roasted pork, hailed as the world\'s best.', purposeTags: ['vacation', 'date_idea'], emoji: '🐖', duration: '1–2 hrs'),
    TravelActivity(id: 'cebu_city_3', destinationId: 'cebu_city', title: 'Tops Lookout Sunset', description: 'Panoramic city + sea view from Busay hilltop.', purposeTags: ['date_idea', 'vacation'], emoji: '🌆', duration: '2 hrs'),
    TravelActivity(id: 'cebu_city_4', destinationId: 'cebu_city', title: 'Cebu Heritage Monument', description: 'Sculptural plaza retelling the city\'s 500 years.', purposeTags: ['school_business'], emoji: '🗿', duration: '1 hr'),

    // ── Boracay ──────────────────────────────────────────────
    TravelActivity(id: 'boracay_1', destinationId: 'boracay', title: 'Sunset Paraw Sailing', description: 'Native double-outrigger sailboat at golden hour.', purposeTags: ['date_idea', 'vacation'], emoji: '⛵', duration: '1–2 hrs'),
    TravelActivity(id: 'boracay_2', destinationId: 'boracay', title: 'White Beach Stroll', description: 'Powdery 4 km stretch — Stations 1, 2, 3 vibes.', purposeTags: ['vacation', 'date_idea'], emoji: '🏖️', duration: 'Half day'),
    TravelActivity(id: 'boracay_3', destinationId: 'boracay', title: 'Helmet Diving / Parasailing', description: 'Underwater walks among tropical fish, no license needed.', purposeTags: ['vacation'], emoji: '🤿', duration: '2 hrs'),

    // ── Bohol ────────────────────────────────────────────────
    TravelActivity(id: 'bohol_1', destinationId: 'bohol', title: 'Chocolate Hills Lookout', description: '1,200+ symmetrical hills — best at golden hour.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🍫', duration: '2 hrs'),
    TravelActivity(id: 'bohol_2', destinationId: 'bohol', title: 'Loboc River Cruise Lunch', description: 'Floating buffet through bamboo-lined river.', purposeTags: ['date_idea', 'vacation'], emoji: '🚢', duration: '2 hrs'),
    TravelActivity(id: 'bohol_3', destinationId: 'bohol', title: 'Tarsier Sanctuary', description: 'See the world\'s smallest primate in a protected forest.', purposeTags: ['vacation', 'school_business'], emoji: '🐒', duration: '1–2 hrs'),
    TravelActivity(id: 'bohol_4', destinationId: 'bohol', title: 'Panglao Beach Resort Day', description: 'Alona Beach diving, swim-up bars, beach cabanas.', purposeTags: ['vacation', 'date_idea'], emoji: '🏖️', duration: 'Full day'),

    // ── Dumaguete ────────────────────────────────────────────
    TravelActivity(id: 'dumaguete_1', destinationId: 'dumaguete', title: 'Apo Island Snorkel', description: 'Sea turtles in crystal water near a marine sanctuary.', purposeTags: ['vacation', 'school_business'], emoji: '🐢', duration: 'Full day'),
    TravelActivity(id: 'dumaguete_2', destinationId: 'dumaguete', title: 'Rizal Boulevard Sunset', description: 'Seaside walk, silvanas, and student-town cafes.', purposeTags: ['date_idea', 'vacation'], emoji: '🌅', duration: '2 hrs'),
    TravelActivity(id: 'dumaguete_3', destinationId: 'dumaguete', title: 'Casaroro Falls Hike', description: 'Steep-stair descent into a forest plunge pool.', purposeTags: ['vacation', 'date_idea'], emoji: '💧', duration: '3 hrs'),

    // ── Iloilo ───────────────────────────────────────────────
    TravelActivity(id: 'iloilo_1', destinationId: 'iloilo', title: 'La Paz Batchoy Lunch', description: 'Steaming pork-broth noodles at the original market.', purposeTags: ['vacation', 'date_idea'], emoji: '🍜', duration: '1 hr'),
    TravelActivity(id: 'iloilo_2', destinationId: 'iloilo', title: 'Miag-ao Church Heritage', description: 'UNESCO baroque-fortress church with relief carvings.', purposeTags: ['school_business', 'date_idea'], emoji: '⛪', duration: '2 hrs'),
    TravelActivity(id: 'iloilo_3', destinationId: 'iloilo', title: 'Iloilo River Esplanade', description: 'Green riverside walkway — joggers, food stalls, sunsets.', purposeTags: ['date_idea', 'vacation'], emoji: '🚶', duration: '1–2 hrs'),

    // ── Bacolod ──────────────────────────────────────────────
    TravelActivity(id: 'bacolod_1', destinationId: 'bacolod', title: 'Chicken Inasal Dinner', description: 'Charcoal-grilled chicken with vinegar-soy-calamansi.', purposeTags: ['vacation', 'date_idea'], emoji: '🍗', duration: '1 hr'),
    TravelActivity(id: 'bacolod_2', destinationId: 'bacolod', title: 'The Ruins (Talisay)', description: 'Italianate mansion shell, flood-lit at night.', purposeTags: ['date_idea', 'school_business'], emoji: '🏛️', duration: '2 hrs'),
    TravelActivity(id: 'bacolod_3', destinationId: 'bacolod', title: 'MassKara Festival (Oct)', description: 'Smiling-mask dance contests fill the streets in October.', purposeTags: ['vacation', 'school_business'], emoji: '🎭', duration: 'Full day'),

    // ── Tacloban ─────────────────────────────────────────────
    TravelActivity(id: 'tacloban_1', destinationId: 'tacloban', title: 'San Juanico Bridge View', description: 'PH\'s longest sea-spanning bridge — best from Sto. Niño hill.', purposeTags: ['school_business', 'date_idea'], emoji: '🌉', duration: '1 hr'),
    TravelActivity(id: 'tacloban_2', destinationId: 'tacloban', title: 'MacArthur Landing Park', description: 'Iconic life-sized bronze landing statues at Red Beach.', purposeTags: ['school_business', 'vacation'], emoji: '🪖', duration: '1–2 hrs'),
    TravelActivity(id: 'tacloban_3', destinationId: 'tacloban', title: 'Sto. Niño Shrine', description: 'Imelda Marcos\' lavish heritage mansion — tour inside.', purposeTags: ['school_business', 'date_idea'], emoji: '🏰', duration: '1 hr'),

    // ── Malapascua ───────────────────────────────────────────
    TravelActivity(id: 'malapascua_1', destinationId: 'malapascua', title: 'Thresher Shark Dawn Dive', description: 'Watch threshers being cleaned at Monad Shoal at sunrise.', purposeTags: ['vacation', 'school_business'], emoji: '🦈', duration: '4 hrs'),
    TravelActivity(id: 'malapascua_2', destinationId: 'malapascua', title: 'Bounty Beach Sunset', description: 'Powder-sand strip with beach-bar fire dancers.', purposeTags: ['date_idea', 'vacation'], emoji: '🔥', duration: '2 hrs'),
    TravelActivity(id: 'malapascua_3', destinationId: 'malapascua', title: 'Kalanggaman Day Trip', description: 'Picture-perfect sandbar island, lunch on the sand.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Full day'),

    // ── Moalboal ─────────────────────────────────────────────
    TravelActivity(id: 'moalboal_1', destinationId: 'moalboal', title: 'Sardine Run Free Dive', description: 'Massive baitball spirals just steps off Panagsama beach.', purposeTags: ['vacation'], emoji: '🐟', duration: '2 hrs'),
    TravelActivity(id: 'moalboal_2', destinationId: 'moalboal', title: 'Kawasan Canyoneering', description: 'Cliff jumps and turquoise pools through Kawasan canyon.', purposeTags: ['vacation', 'date_idea'], emoji: '🪂', duration: 'Full day'),
    TravelActivity(id: 'moalboal_3', destinationId: 'moalboal', title: 'Pescador Island Snorkel', description: 'Wall dives and turtle sightings on a tiny rock isle.', purposeTags: ['vacation', 'school_business'], emoji: '🐢', duration: 'Half day'),

    // ── Camiguin ─────────────────────────────────────────────
    TravelActivity(id: 'camiguin_1', destinationId: 'camiguin', title: 'White Island Sandbar', description: 'Pure-white sandbar with all 7 volcanoes as backdrop.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Half day'),
    TravelActivity(id: 'camiguin_2', destinationId: 'camiguin', title: 'Sunken Cemetery Cross', description: 'Snorkel down to a cross built over a quake-sunken graveyard.', purposeTags: ['vacation', 'school_business'], emoji: '✝️', duration: '2 hrs'),
    TravelActivity(id: 'camiguin_3', destinationId: 'camiguin', title: 'Ardent Hot Springs Soak', description: 'Volcano-warmed pools tucked in jungle.', purposeTags: ['date_idea', 'vacation'], emoji: '♨️', duration: '2 hrs'),

    // ── Siquijor ─────────────────────────────────────────────
    TravelActivity(id: 'siquijor_1', destinationId: 'siquijor', title: 'Cambugahay Falls Swim', description: 'Tiered turquoise pools with rope swings.', purposeTags: ['vacation', 'date_idea'], emoji: '💦', duration: '2 hrs'),
    TravelActivity(id: 'siquijor_2', destinationId: 'siquijor', title: 'Old Balete Tree Fish Spa', description: '400-year-old tree, foot dip with curious fish.', purposeTags: ['date_idea', 'school_business'], emoji: '🌳', duration: '1 hr'),
    TravelActivity(id: 'siquijor_3', destinationId: 'siquijor', title: 'Salagdoong Cliff Jump', description: 'Two cliff platforms over emerald-clear sea.', purposeTags: ['vacation', 'date_idea'], emoji: '🪂', duration: '2 hrs'),

    // ── Guimaras ─────────────────────────────────────────────
    TravelActivity(id: 'guimaras_1', destinationId: 'guimaras', title: 'Mango Pizza & Farm', description: 'World\'s sweetest mangoes, served as pizza, ice cream, jam.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🥭', duration: '2 hrs'),
    TravelActivity(id: 'guimaras_2', destinationId: 'guimaras', title: 'Island Hop — Ave Maria', description: 'Tiny islets, snorkeling, and lunch on the sand.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Half day'),
    TravelActivity(id: 'guimaras_3', destinationId: 'guimaras', title: 'Trappist Monastery Visit', description: 'Quiet hilltop chapel and monk-made mango jam shop.', purposeTags: ['school_business', 'date_idea'], emoji: '🛐', duration: '1 hr'),

    // ── Bantayan ─────────────────────────────────────────────
    TravelActivity(id: 'bantayan_1', destinationId: 'bantayan', title: 'Sugar Beach Lazy Day', description: 'Soft white sand and shallow turquoise — pure unwind.', purposeTags: ['vacation', 'date_idea'], emoji: '🏖️', duration: 'Full day'),
    TravelActivity(id: 'bantayan_2', destinationId: 'bantayan', title: 'Virgin Island Boat', description: 'Tiny private-feel island a short banca ride away.', purposeTags: ['vacation', 'date_idea'], emoji: '⛵', duration: 'Half day'),
    TravelActivity(id: 'bantayan_3', destinationId: 'bantayan', title: 'Sts. Peter & Paul Church', description: '1580 coral-stone church, oldest in the Visayas.', purposeTags: ['school_business', 'date_idea'], emoji: '⛪', duration: '1 hr'),

    // ── Kalibo ───────────────────────────────────────────────
    TravelActivity(id: 'kalibo_1', destinationId: 'kalibo', title: 'Ati-Atihan Festival (Jan)', description: 'Drum-pounding street dance — \'mother of all PH festivals\'.', purposeTags: ['vacation', 'school_business'], emoji: '🥁', duration: 'Full day'),
    TravelActivity(id: 'kalibo_2', destinationId: 'kalibo', title: 'Bakhawan Eco-Park', description: 'Mangrove boardwalk through lush coastal forest.', purposeTags: ['school_business', 'date_idea', 'vacation'], emoji: '🌿', duration: '2 hrs'),
    TravelActivity(id: 'kalibo_3', destinationId: 'kalibo', title: 'Piña Cloth Workshop', description: 'See pineapple-fiber weaving, the source of barong fabric.', purposeTags: ['school_business', 'vacation'], emoji: '🧵', duration: '2 hrs'),

    // ── Borongan ─────────────────────────────────────────────
    TravelActivity(id: 'borongan_1', destinationId: 'borongan', title: 'Baybay Boulevard Surf', description: 'Untouched Pacific swells, no crowds.', purposeTags: ['vacation'], emoji: '🏄', duration: '3 hrs'),
    TravelActivity(id: 'borongan_2', destinationId: 'borongan', title: 'Divinubo Island Boat', description: 'Coral-fringed islet 15 mins offshore — picnic-friendly.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Half day'),
    TravelActivity(id: 'borongan_3', destinationId: 'borongan', title: 'Hamorawon Spring', description: 'Cool freshwater spring popular with locals.', purposeTags: ['date_idea', 'school_business'], emoji: '💦', duration: '1–2 hrs'),

    // ── Davao ────────────────────────────────────────────────
    TravelActivity(id: 'davao_1', destinationId: 'davao', title: 'Philippine Eagle Center', description: 'See the critically endangered national bird up close.', purposeTags: ['school_business', 'vacation', 'date_idea'], emoji: '🦅', duration: '2–3 hrs'),
    TravelActivity(id: 'davao_2', destinationId: 'davao', title: 'Roxas Night Market', description: 'Grilled seafood, tuna panga, ihaw-ihaw till midnight.', purposeTags: ['vacation', 'date_idea'], emoji: '🍢', duration: '2 hrs'),
    TravelActivity(id: 'davao_3', destinationId: 'davao', title: 'Eden Nature Park', description: 'Mountain resort — flower farms, ziplines, cool air.', purposeTags: ['vacation', 'date_idea'], emoji: '🌺', duration: 'Half day'),
    TravelActivity(id: 'davao_4', destinationId: 'davao', title: 'Mt. Apo Day Hike Base', description: 'Take a guided trek to Lake Venado base camp.', purposeTags: ['vacation', 'school_business'], emoji: '⛰️', duration: 'Full day'),

    // ── Siargao ──────────────────────────────────────────────
    TravelActivity(id: 'siargao_1', destinationId: 'siargao', title: 'Cloud 9 Surf Lesson', description: 'World-class right-hand reef break, lessons available.', purposeTags: ['vacation'], emoji: '🏄', duration: '3 hrs'),
    TravelActivity(id: 'siargao_2', destinationId: 'siargao', title: 'Sugba Lagoon Diving Board', description: 'Mangrove-lined lagoon with a high-jump platform.', purposeTags: ['vacation', 'date_idea'], emoji: '💦', duration: 'Full day'),
    TravelActivity(id: 'siargao_3', destinationId: 'siargao', title: 'Magpupungko Rock Pools', description: 'Tidal pools beside a rock formation — only at low tide.', purposeTags: ['date_idea', 'vacation'], emoji: '🏊', duration: '3–4 hrs'),
    TravelActivity(id: 'siargao_4', destinationId: 'siargao', title: 'Coconut Road Motorbike', description: 'Endless palm-lined road — the iconic Siargao photo.', purposeTags: ['date_idea', 'school_business'], emoji: '🌴', duration: '2 hrs'),

    // ── CDO ──────────────────────────────────────────────────
    TravelActivity(id: 'cdo_1', destinationId: 'cdo', title: 'White-Water Rafting', description: 'Cagayan River rapids — beginner to advanced courses.', purposeTags: ['vacation', 'school_business'], emoji: '🚣', duration: 'Half day'),
    TravelActivity(id: 'cdo_2', destinationId: 'cdo', title: 'Dahilayan Adventure Park', description: 'Asia\'s longest dual zipline, plus rope courses.', purposeTags: ['vacation', 'date_idea'], emoji: '🪂', duration: 'Full day'),
    TravelActivity(id: 'cdo_3', destinationId: 'cdo', title: 'Divisoria Night Market', description: 'Walking street with grilled food, live music.', purposeTags: ['date_idea', 'vacation'], emoji: '🎤', duration: '2 hrs'),

    // ── GenSan ───────────────────────────────────────────────
    TravelActivity(id: 'gensan_1', destinationId: 'gensan', title: 'Tuna Sashimi Lunch', description: 'Fresh-from-the-port yellowfin sashimi at fish-port stalls.', purposeTags: ['vacation', 'date_idea'], emoji: '🍣', duration: '1–2 hrs'),
    TravelActivity(id: 'gensan_2', destinationId: 'gensan', title: 'Sarangani Bay Dolphin Watch', description: 'Boat trips to spot pods of spinner dolphins.', purposeTags: ['vacation', 'school_business'], emoji: '🐬', duration: 'Half day'),
    TravelActivity(id: 'gensan_3', destinationId: 'gensan', title: 'Gumasa Beach Day', description: 'Powdery white sand 2 hrs south — quiet weekday escape.', purposeTags: ['date_idea', 'vacation'], emoji: '🏖️', duration: 'Full day'),

    // ── Zamboanga ────────────────────────────────────────────
    TravelActivity(id: 'zamboanga_1', destinationId: 'zamboanga', title: 'Pink Sand Beach (Sta. Cruz)', description: 'Naturally pink sand from crushed red coral.', purposeTags: ['vacation', 'date_idea', 'school_business'], emoji: '🌸', duration: 'Half day'),
    TravelActivity(id: 'zamboanga_2', destinationId: 'zamboanga', title: 'Fort Pilar Shrine', description: 'Spanish-era fortress chapel facing the sea.', purposeTags: ['school_business', 'date_idea'], emoji: '🏰', duration: '1 hr'),
    TravelActivity(id: 'zamboanga_3', destinationId: 'zamboanga', title: 'Vinta Sail at Paseo', description: 'Colorful Tausug sailboats decorating the bay.', purposeTags: ['date_idea', 'vacation'], emoji: '⛵', duration: '1–2 hrs'),

    // ── Bukidnon ─────────────────────────────────────────────
    TravelActivity(id: 'bukidnon_1', destinationId: 'bukidnon', title: 'Dahilayan Pineapple Fields', description: 'Endless rolling pineapple plantation views.', purposeTags: ['date_idea', 'school_business'], emoji: '🍍', duration: '2 hrs'),
    TravelActivity(id: 'bukidnon_2', destinationId: 'bukidnon', title: 'Communal Ranch Horseback', description: 'Open grasslands ride — feels like Mongolia.', purposeTags: ['vacation', 'date_idea'], emoji: '🐎', duration: '2 hrs'),
    TravelActivity(id: 'bukidnon_3', destinationId: 'bukidnon', title: 'Monastery of Transfiguration', description: 'Pyramid chapel by national artist Locsin.', purposeTags: ['school_business', 'date_idea'], emoji: '🛐', duration: '1–2 hrs'),

    // ── Lake Sebu ────────────────────────────────────────────
    TravelActivity(id: 'lake_sebu_1', destinationId: 'lake_sebu', title: 'Seven Falls Zipline', description: 'Twin zipline over the canyon — falls below your feet.', purposeTags: ['vacation', 'date_idea'], emoji: '🪂', duration: '3 hrs'),
    TravelActivity(id: 'lake_sebu_2', destinationId: 'lake_sebu', title: 'T\'boli Weaving Center', description: 'See \'dream weavers\' make T\'nalak abaca textiles.', purposeTags: ['school_business', 'vacation'], emoji: '🧵', duration: '2 hrs'),
    TravelActivity(id: 'lake_sebu_3', destinationId: 'lake_sebu', title: 'Tilapia Lakeside Lunch', description: 'Grilled tilapia from floating lake-house restaurants.', purposeTags: ['date_idea', 'vacation'], emoji: '🍴', duration: '1–2 hrs'),

    // ── Iligan ───────────────────────────────────────────────
    TravelActivity(id: 'iligan_1', destinationId: 'iligan', title: 'Maria Cristina Falls', description: 'Twin-jet 320-foot falls — Mindanao\'s most powerful.', purposeTags: ['vacation', 'school_business', 'date_idea'], emoji: '💧', duration: '2 hrs'),
    TravelActivity(id: 'iligan_2', destinationId: 'iligan', title: 'Tinago Falls Descent', description: '500 steps down to a hidden plunge pool with raft.', purposeTags: ['vacation', 'date_idea'], emoji: '💦', duration: '3 hrs'),
    TravelActivity(id: 'iligan_3', destinationId: 'iligan', title: 'NPC Nature\'s Park', description: 'Forested park, old hydro-plant, picnic areas.', purposeTags: ['date_idea', 'school_business'], emoji: '🌳', duration: '2 hrs'),

    // ── Cotabato ─────────────────────────────────────────────
    TravelActivity(id: 'cotabato_1', destinationId: 'cotabato', title: 'Grand Mosque Tour', description: 'Largest mosque in the Philippines — gold-domed.', purposeTags: ['school_business', 'date_idea', 'vacation'], emoji: '🕌', duration: '1 hr'),
    TravelActivity(id: 'cotabato_2', destinationId: 'cotabato', title: 'Pagana Maguindanao Dinner', description: 'Royal Maguindanao feast — tiyula itum, pyanggang.', purposeTags: ['vacation', 'date_idea'], emoji: '🍛', duration: '1–2 hrs'),
    TravelActivity(id: 'cotabato_3', destinationId: 'cotabato', title: 'Tantawan Park View', description: 'Panoramic view of the city and Rio Grande river.', purposeTags: ['date_idea', 'school_business'], emoji: '🌆', duration: '1 hr'),

    // ── Bislig ───────────────────────────────────────────────
    TravelActivity(id: 'bislig_1', destinationId: 'bislig', title: 'Tinuy-an Falls', description: 'Three-tiered, 95-meter wide curtain of water.', purposeTags: ['vacation', 'school_business', 'date_idea'], emoji: '🌊', duration: '3 hrs'),
    TravelActivity(id: 'bislig_2', destinationId: 'bislig', title: 'Enchanted River (Hinatuan)', description: 'Otherworldly deep-blue spring river, nearby town.', purposeTags: ['vacation', 'date_idea'], emoji: '💎', duration: 'Full day'),
    TravelActivity(id: 'bislig_3', destinationId: 'bislig', title: 'Britania Group of Islands', description: '24 emerald-water islets — quiet and wild.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Full day'),

    // ── Pagadian ─────────────────────────────────────────────
    TravelActivity(id: 'pagadian_1', destinationId: 'pagadian', title: 'Dao-Dao Islands Picnic', description: 'Twin islets just off the bay — quick boat trip.', purposeTags: ['vacation', 'date_idea'], emoji: '🏝️', duration: 'Half day'),
    TravelActivity(id: 'pagadian_2', destinationId: 'pagadian', title: 'Pulacan Falls', description: 'Curtain falls 30 mins from town — easy access.', purposeTags: ['vacation', 'date_idea'], emoji: '💧', duration: '2 hrs'),
    TravelActivity(id: 'pagadian_3', destinationId: 'pagadian', title: 'Rotonda Pasalubong', description: 'Try satti — Zamboanga-style spicy mini skewers.', purposeTags: ['date_idea', 'school_business'], emoji: '🍢', duration: '1 hr'),

    // ── Butuan ───────────────────────────────────────────────
    TravelActivity(id: 'butuan_1', destinationId: 'butuan', title: 'Balangay Shrine Museum', description: 'Pre-colonial wooden boats, 320 AD origin — incredible.', purposeTags: ['school_business', 'date_idea'], emoji: '🛶', duration: '2 hrs'),
    TravelActivity(id: 'butuan_2', destinationId: 'butuan', title: 'Agusan River Cruise', description: 'River life cruise to nearby fishing villages.', purposeTags: ['vacation', 'date_idea'], emoji: '🚢', duration: '3 hrs'),
    TravelActivity(id: 'butuan_3', destinationId: 'butuan', title: 'Mt. Mayapay Day Hike', description: 'Forested mountain with city panorama at peak.', purposeTags: ['vacation', 'school_business'], emoji: '⛰️', duration: 'Full day'),
  ];

  static List<TravelActivity> forDestination(String destinationId, {String? purpose}) {
    final filtered = all.where((a) => a.destinationId == destinationId);
    if (purpose == null) return filtered.toList();
    final matched = filtered.where((a) => a.purposeTags.contains(purpose)).toList();
    return matched.isEmpty ? filtered.take(3).toList() : matched;
  }
}
