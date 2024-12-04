--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--config.AddToSystem("Attribute Progression Scale", "scale_attribute_progress", "The amount to scale attribute progress by.");
config.AddToSystem("Messages Must See Player", "messages_must_see_player", "Si vous devez ou non voir un joueur pour entendre certains messages du personnage.");
--config.AddToSystem("Starting Attribute Points", "default_attribute_points", "The default amount of attribute points that a player has.");
--config.AddToSystem("Clockwork Introduction Enabled", "clockwork_intro_enabled", "Enable the Clockwork introduction for new players.");
config.AddToSystem("Health Regeneration Enabled", "health_regeneration_enabled", "Que la régénération de la santé soit activée ou non.");
config.AddToSystem("Prop Protection Enabled", "enable_prop_protection", "Activer ou non la protection des accessoires.");
config.AddToSystem("Use Local Machine Date", "use_local_machine_date", "Utiliser ou non la date de la machine locale lors du chargement de la carte.");
config.AddToSystem("Use Local Machine Time", "use_local_machine_time", "Utiliser ou non l'heure de la machine locale lors du chargement de la carte.");
config.AddToSystem("Use Key Opens Entity Menus", "use_opens_entity_menus", "Si  'utiliser'  ouvre ou non les menus contextuels.");
config.AddToSystem("Shoot After Raise Delay", "shoot_after_raise_time", "Le temps qu'il faut aux joueurs pour pouvoir tirer après avoir levé leur arme (secondes).\nRéglé sur 0 pour aucun temps.");
config.AddToSystem("Use Clockwork's Admin System", "use_own_group_system", "Que vous utilisiez ou non un groupe ou un système d'administration différent de Clockwork.");
config.AddToSystem("Saved Recognised Names", "save_recognised_names", "Les noms reconnus doivent-ils être enregistrés ou non ?.");
--config.AddToSystem("Save Attribute Boosts", "save_attribute_boosts", "Whether or not attribute boosts are saved.");
config.AddToSystem("Ragdoll Damage Immunity Time", "ragdoll_immunity_time", "Le temps pendant lequel la poupée de chiffon d'un joueur est immunisée contre les dégâts (secondes).", 0, 5, 3);
config.AddToSystem("Additional Character Count", "additional_characters", "Le nombre supplémentaire de personnages que chaque joueur peut avoir.");
config.AddToSystem("Faction Ratio System Enabled", "faction_ratio_enabled", "Que le système de ratio de faction soit activé ou non.");
config.AddToSystem("Class Changing Interval", "change_class_interval", "Le temps qu'un joueur doit attendre pour changer à nouveau de classe (secondes).", 0, 7200);
config.AddToSystem("Sprinting Lowers Weapon", "sprint_lowers_weapon", "Si le sprint abaisse ou non l'arme d'un joueur.");
config.AddToSystem("Weapon Raising System Enabled", "raised_weapon_system", "Que le système d'arme levée soit activé ou non.");
config.AddToSystem("Prop Kill Protection Enabled", "prop_kill_protection", "Si la protection contre la destruction des accessoires est activée ou non.");
config.AddToSystem("Gravity Gun Punt Enabled", "enable_gravgun_punt", "S'il faut ou non permettre aux entités d'être frappées avec le pistolet à gravité.");
config.AddToSystem("Default Inventory Weight", "default_inv_weight", "Le poids de l'inventaire par défaut (kilogrammes).");
config.AddToSystem("Default Inventory Space", "default_inv_space", "L'espace d'inventaire par défaut (litres).");
config.AddToSystem("Data Save Interval", "save_data_interval", "Le temps nécessaire à la sauvegarde des données (en secondes).", 0, 7200);
config.AddToSystem("View Punch On Damage", "damage_view_punch", "Si la vue d'un joueur est frappée ou non lorsqu'il subit des dégâts.");
config.AddToSystem("Unrecognised Name", "unrecognised_name", "Le nom donné aux joueurs non reconnus.");
config.AddToSystem("Limb Damage Scale", "scale_limb_dmg", "Le montant à mettre à l'échelle des dommages aux membres par.", 0, 2, 2);
config.AddToSystem("Fall Damage Scale", "scale_fall_damage", "Le montant à mettre à l'échelle des dégâts de chute par.", 0, 2, 2);
config.AddToSystem("Starting Currency", "default_cash", "Le montant d'argent par défaut avec lequel chaque joueur commence.", 0, 10000);
--config.AddToSystem("Armor Affects Chest Only", "armor_chest_only", "Whether or not armor only affects the chest.");
config.AddToSystem("Minimum Physical Description Length", "minimum_physdesc", "Le nombre minimum de caractères qu'un joueur doit avoir dans sa description physique.", 0, 128);
config.AddToSystem("Wood Breaks Fall", "wood_breaks_fall", "Si les entités physiques en bois amortissent ou non la chute d'un joueur.");
config.AddToSystem("Vignette Enabled", "enable_vignette", "Que la vignette soit activée ou non.");
config.AddToSystem("Heartbeat Sounds Enabled", "enable_heartbeat", "Que le battement de cœur soit activé ou non.");
config.AddToSystem("Crosshair Enabled", "enable_crosshair", "Que le réticule soit activé ou non.");
config.AddToSystem("Free Aiming Enabled", "use_free_aiming", "Que la visée libre soit activée ou non.");
config.AddToSystem("Recognise System Enabled", "recognise_system", "Que le système de reconnaissance soit activé ou non.");
config.AddToSystem("Currency Enabled", "cash_enabled", "Que l'argent liquide soit autorisé ou non.");
config.AddToSystem("Default Physical Description", "default_physdesc", "La description physique avec laquelle chaque joueur commence.");
config.AddToSystem("Chest Damage Scale", "scale_chest_dmg", "Le montant à mettre à l'échelle des dégâts de poitrine par.");
config.AddToSystem("Corpse Decay Time", "body_decay_time", "Le temps qu'il faut à la poupée de chiffon d'un joueur pour se décomposer (secondes).", 0, 7200);
config.AddToSystem("Banned Disconnect Message", "banned_message", "Le message qu'un joueur reçoit lorsqu'il essaie de rejoindre alors qu'il est banni.\n!t pour le temps restant, !f pour le format de l'heure.");
config.AddToSystem("Wages Interval", "wages_interval", "Le temps nécessaire pour que les salaires en espèces soient distribués (secondes).", 0, 7200);
config.AddToSystem("Prop Cost Scale", "scale_prop_cost", "How to much to scale prop cost by.\nRéglez sur 0 pour rendre les accessoires gratuits.");
config.AddToSystem("Fade NPC Corpses", "fade_dead_npcs", "Faut-il ou non faire disparaître les PNJ morts ?");
config.AddToSystem("Cash Weight", "cash_weight", "Le poids de l'argent liquide (kilogrammes).", 0, 100, 3);
config.AddToSystem("Cash Space", "cash_space", "Quantité d'espace occupé par l'argent liquide (litres).", 0, 100, 3);
config.AddToSystem("Head Damage Scale", "scale_head_dmg", "Le montant à mettre à l'échelle pour les dégâts à la tête.");
--config.AddToSystem("Block Inventory Binds", "block_inv_binds", "Whether or not inventory binds should be blocked for players.");
config.AddToSystem("Target ID Delay", "target_id_delay", "Le délai avant que l'ID cible ne s'affiche lorsque l'on regarde une entité.");
config.AddToSystem("Headbob Enabled", "enable_headbob", "Activer ou non le headbob.");
config.AddToSystem("Chat Command Prefix", "command_prefix", "Le préfixe utilisé pour les commandes de chat.");
config.AddToSystem("Crouch Walk Speed", "crouched_speed", "La vitesse à laquelle les personnages marchent lorsqu'ils sont accroupis.", 0, 1024);
config.AddToSystem("Maximum Chat Length", "max_chat_length", "Le nombre maximum de caractères pouvant être saisis dans le chat.", 0, 1024);
config.AddToSystem("Starting Flags", "default_flags", "Les drapeaux avec lesquels chaque joueur commence.");
config.AddToSystem("Player Spray Enabled", "disable_sprays", "Si les joueurs peuvent pulvériser leurs tags.");
config.AddToSystem("Hint Interval", "hint_interval", "Le temps pendant lequel un indice est affiché à chaque joueur (secondes).", 0, 7200);
config.AddToSystem("Out-Of-Character Chat Interval", "ooc_interval", "Le temps qu'un joueur doit attendre pour parler à nouveau hors de son personnage (en secondes).\nRégler à 0 pour jamais.", 0, 7200);
config.AddToSystem("Local-Out-Of-Character Chat Interval", "looc_interval", "Le temps qu'un joueur doit attendre pour parler à nouveau en local, hors de son personnage (en secondes).\nRégler à 0 pour jamais", 0, 7200);
config.AddToSystem("Global Out-Of-Character Chat Enabled", "global_ooc_enabled", "Si le chat OOC global est activé ou non.");
config.AddToSystem("Minute Time", "minute_time", "Le temps qu'il faut pour qu'une minute s'écoule (secondes).", 0, 7200);
config.AddToSystem("Door Unlock Interval", "unlock_time", "Le temps qu'un joueur doit attendre pour déverrouiller une porte (secondes).", 0, 7200);
config.AddToSystem("Voice Chat Enabled", "voice_enabled", "Si le chat vocal est activé ou non.");
config.AddToSystem("Local Voice Chat", "local_voice", "Activer ou non la voix locale.");
config.AddToSystem("Talk Radius", "talk_radius", "Le rayon de chaque joueur dans lequel les autres personnages doivent se trouver pour les entendre parler (unités).", 0, 4096);
config.AddToSystem("Give Hands", "give_hands", "Donner ou non la main à chaque joueur.");
config.AddToSystem("Custom Weapon Color", "custom_weapon_color", "Activer ou non les couleurs d'armes personnalisées.");
config.AddToSystem("Give Keys", "give_keys", "Donner ou non les clés à chaque joueur.");
config.AddToSystem("Wages Name", "wages_name", "Le nom donné aux salaires.");
config.AddToSystem("Jump Power", "jump_power", "Le pouvoir sur lequel les personnages sautent.", 0, 1024);
config.AddToSystem("Respawn Delay", "spawn_time", "Le temps qu'un joueur doit attendre avant de pouvoir réapparaître (secondes).", 0, 7200);
config.AddToSystem("Maximum Walk Speed", "walk_speed", "La vitesse à laquelle les personnages marchent.", 0, 1024);
config.AddToSystem("Maximum Run Speed", "run_speed", "La vitesse à laquelle courent les personnages.", 0, 1024);
--config.AddToSystem("Door Price", "door_cost", "The amount of cash that each door costs.");
config.AddToSystem("Door Lock Interval", "lock_time", "Le temps qu'un joueur doit attendre pour verrouiller une porte (en secondes).", 0, 7200);
--config.AddToSystem("Maximum Ownable Doors", "max_doors", "The maximum amount of doors a player can own.");
config.AddToSystem("Enable Space System", "enable_space_system", "Utiliser ou non le système spatial qui affecte les inventaires.");
--config.AddToSystem("Draw Intro Bars", "draw_intro_bars", "Whether or not to draw cinematic intro black bars on top and bottom of the screen.");
config.AddToSystem("Enable LOOC Icons", "enable_looc_icons", "Activer ou non les icônes de discussion LOOC.");
--config.AddToSystem("Show Business Menu", "show_business", "Whether or not to show the business menu.");
config.AddToSystem("Enable Chat Multiplier", "chat_multiplier", "S'il faut ou non modifier la taille du texte en fonction des types de discussion.");
config.AddToSystem("Enable Map Props Physgrab", "enable_map_props_physgrab", "Si les joueurs pourront ou non récupérer des accessoires de carte et des portes avec des fusils physiques.");
config.AddToSystem("Entity Use Cooldown", "entity_handle_time", "Le temps qu'un joueur doit attendre entre chaque utilisation d'une entité.", 0, 1, 3);
--config.AddToSystem("Enable Quick Raise", "quick_raise_enabled", "Whether or not players can use quick raising to raise their weapons.");
config.AddToSystem("Block Cash Commands Binds", "block_cash_binds", "Qu'il faille ou non bloquer les commandes en espèces.")
config.AddToSystem("Block Fallover Binds", "block_fallover_binds", "S'il faut ou non bloquer les liaisons charfallover.")
config.AddToSystem("Max Traits", "max_trait_points", "Le nombre maximum de traits que chaque personnage peut avoir.")
config.AddToSystem("Item Lifetime", "item_lifetime", "Durée de vie des éléments supprimés en secondes avant leur suppression. Persiste entre les redémarrages du serveur. Les éléments générés par script ont pour la plupart leur propre durée de vie, plus courte que la durée par défaut.", 1800, 28800);