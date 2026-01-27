class_name NpcGen

signal books_reload

const GREET = [
	"Hey, it's good to see you. ",
	"How's it going? ",
	"Wow, the farm looks great! ",
	"Man it's been a while, huh? ",
	"Hi, how've you been? "
	]
	
const BEGIN = [
	"Can I get the usual ",
	"Same as always, I'll have a ",
	"Could I get a ",
	"Hm, let's switch things up and do a ",
	"The usual please. "
]

const WITH = " with "

var DIALOGUE: Dictionary = {
	"NPC_1" = {
		"NAME" = "Yan-Chen",
		"ORDER" = preload("res://resources/game_data/drinks/plain_black.tres"),
		"TEA" = Static.TEA.CEYLON,
		"DIALOGUE" = [
			["Hello there! You’re a new face.", "Oh, is he doing alright?", "… I see.", "A business trip, huh?", "Name’s Yan-Chen, by the way. I’ll be back to check on you soon. Been coming here for years. Your grandpa n’ me were pretty close.", ". . . . .", "Well… Give me my usual. Just a Ceylon Tea."],
			["Hello, again. How are you holdin up?", "How’s taking over the business been?", "Good things ain’t won easy. That’s for sure. You know what always keeps me motivated?", "A cup of Ceylon tea."],
			["Hangin in there, kiddo?", "Don't feel too bad about your grandpa. I’ve known that man for years, and he didn’t say nothin’ to me either.", "Can’t say it was all that hard to see toward the end.", "You know how he was. He was a proud man.", "What’s your plan? Do you think you'll stay?", "What’s complicated about it?", "Finances. That’s always what gets ya, isn’t it?", "The usual, please. Good ol' Ceylon. You know you make a cuppa just as well as your grandpa did."],
			["Hey, kiddo. How's it going?", "Weird crops, huh?", "Y’know your grandpa said something about that once. Hold on a sec.", "I think it’s in here. I keep all my correspondences. As should you.", "Never know when ya might need that information, like today.", "I’m sure you know the strange tales about this island.", "I ain’t saying there is any truth to it... But.", "Well, you just read that and make up your own mind about it.", "I have some old books of your grandpa's as well. You should have them...", "And I'll take my usual Ceylon.",],
		],
		"UNLOCK" = false,
		"BOOKS" = [Static.BOOKS.OLD_LETTER, Static.BOOKS.BOBA_HISTORY, Static.BOOKS.CASSAVA_PROCESS]
	},
	"NPC_2" = {
		"NAME" = "Dr. Green",
		"ORDER" = preload("res://resources/game_data/drinks/plain_black_boba.tres"),
		"TEA" = Static.TEA.OOLONG,
		"DIALOGUE" = [
			["What an intriguing shop you have here.", "Have you lived here long?", "Can you tell me about the history of this shop?", "Amazing. It’s no surprise this shop has stayed in business for nearly half a century. What a brilliant idea to have a boat drive-thru.", "Are you familiar with the folklore surrounding this island?", "Ah, I can very well imagine that it’s part of what draws customers here.", "Oh, yes. Please forgive me. My name is Dr. Green. I’m an anthropologist, and I was doing research in the area and came across some information on your island. Interesting stuff to say the least.", "Do you grow all your own produce?", "Of course you do. I found an old newspaper clipping about this island and this shop. I’m so glad that it’s still up and running.", "I'll bring it with me sometime. Might be nice to put up on the wall for customers.", "Oh… umm… May I trouble you for an oolong with boba?"],
			["Hello, again.", "You wouldn't happen to have any mutated crops around here? I've been reading up on this little island.", "I see. Still, even without them, there is no lack of intrigue about the place.", "Are you familiar with the myth of Mushu and Cài Yuán?", "It’s especially interesting, given the stories of mutated crops. I'll find it and bring it to you. I’d love to hear your thoughts.", "I’ve extended my residency. There is so much to this place, I’m thinking of writing my own book. Perhaps you’ll allow me a tour of the island sometime.", "For now, how about a tea? Oolong with boba, please."],
			["Cheerio! Any mutated crops or cultists latley?", "You know... It is said that the murdered gods were buried on this very island.", "And did you know that there was once a group of cultists that used to conduct strange rituals on this island?", "They called themselves The Order of Life and Death.", "They were followers of Mushu and Cài Yuán. I found one of their earlier doctrines. It seems harmless enough. I dare say that they even make some good points.", "Apparently, a catastrophe of some kind befell the group, but I’m having a hard time unearthing exactly what happened. It’s all very mysterious.", "I’ll be sure to let you know when I find more out.", "But I won't hold you in suspense any longer, here are those documents I've mentioned.", "A little boost of caffeine will do me some good. Oolong with some boba, please."]
		],
		"UNLOCK" = false,
		"BOOKS" = [Static.BOOKS.CULT_DOCTRINE, Static.BOOKS.MYTH, Static.BOOKS.UNYIELDY]
	},
	"NPC_3" = {
		"NAME" = "Apple",
		"ORDER" = preload("res://resources/game_data/drinks/strawberry_black_boba.tres"),
		"TEA" = Static.TEA.MATCHA,
		"DIALOGUE" = [
			["Who are you?", "Sorry! That wasn’t much of a hello, huh? But I’ve never seen anyone else here besides the old man.", "You must be his new employee? My name is Apple. It’s nice to meet you!", "A drink? That’s why I’m here! I bet you can’t guess what my usual order is.", "I’ll give you a hint. I like fruity things. Which makes sense since my name is Apple, don’tcha think?", "Omg. You must be a mind reader. How did you know?", "It’s your only drink with fruit?", "So you're more of a deducer like a detective, got it!", "More like a deTEActive.", "... We might need to workshop that one.", "Matcha strawberry milk tea. And don't forget the boba!"],
			["You said the old man was your grandfather?", "You know, I used to come around here when I was little with my grandma.", "I’d play here with another child. We’d play hide and seek in the yuca leaves.", "When we’d get hungry, we’d pick strawberries and mush them up with sugar in a bowl.", "It’s actually part of why I love strawberries so much! They taste like happy childhood days on the island.", "I’ve been coming here for a long time to get drinks, but the one you made me last time brought back those memories.", "Sorry to prattle on like that. I’ll take my usual. A matcha strawberry milk tea. With boba!"],
			["I’m back!", "I was thinking about the kid that I used to play with when I was little, and I remembered a crazy day that we had.", "We weren’t supposed to leave the farm without an adult with us, but we were playing that we were adventurers.", "On the far side of the island was a series of little caves. When the tide goes down, there is a deeper hole that you can get into that opens up into a large cavern.", "Sometimes I think back on that moment, and I feel a chill run up my spine over what would have happened if we had still been in there when high tide rolled in.", "Anyway, we had one flashlight and were looking around the cavern when a shadow startled us. We both screamed, and I dropped the flashlight. The batteries popped out, and it was pitch black. So dark I felt like I couldn’t breathe.", "It took forever, both of us feeling around on the cave floor, to find the batteries.", "When we finally did, we discovered the shadow was cast by a little shrine.", "Placed at the foot of the shrine was a flyer. It said some weird stuff about a cult. We were terrified and ran all the way home.", "I still have the flyer if you want to see it again. I'll bring it next time!", "I’ll take a matcha strawberry milk tea, please. And lots of boba!"],
			["Hey, hey! How are you doing today?", "I’ve been feeling so nostalgic lately.", "I was thinking back about my grandma and how much she loved tea.", "She was always drinking matcha, though without any sweetener or anything.", "I always thought it was so grown-up and that when I was older, I’d do the same thing.", "We both know that isn’t going to happen. I always say that the reason I’m so sweet is that I eat so many sweet things.", "Anyway, even though we don’t like the same kinds of tea. She always was so reverent when making it.", "She said the ceremony of making tea was the most important part; the mindful act of making it connected us to the land and created harmony.", "She loved being out here on the island with your grandparents and taking part in farming the ingredients. She’d say it was the ultimate tea ceremony.", "Like I said, I’ve been feeling extra nostalgic lately, and I’ve been reading up on tea ceremonies and thought of all people you’d be able to connect with it to. So I brought you this. Read over it if you get the chance.", "I’ll take my usual. Matcha strawberry milk tea. And lots of boba!"]
		],
		"UNLOCK" = false,
		"BOOKS" = [Static.BOOKS.GONGFU, Static.BOOKS.CULT_FLYER]
	}
}

func get_name(customer_num: int) -> String:
	var customer_name: String = "Regular"
	match customer_num:
		1: customer_name = DIALOGUE.NPC_1.NAME
		2: customer_name = DIALOGUE.NPC_2.NAME
		3: customer_name = DIALOGUE.NPC_3.NAME
	return customer_name + ":"
	
func get_order(customer_num: int) -> Drink:
	var drink: Drink = null
	var tea: int
	match customer_num:
		1:
			drink = DIALOGUE.NPC_1.ORDER
			tea = DIALOGUE.NPC_1.TEA
		2:
			drink = DIALOGUE.NPC_2.ORDER
			tea = DIALOGUE.NPC_2.TEA
		3:
			drink = DIALOGUE.NPC_3.ORDER
			tea = DIALOGUE.NPC_3.TEA
	drink.set_tea_flavor(tea)
	Dynamic.tea_flavor = tea
	return drink

func get_dialogue(customer_num: int) -> Array:
	var dialogue: Array
	match customer_num:
		1: dialogue = DIALOGUE.NPC_1.DIALOGUE
		2: dialogue = DIALOGUE.NPC_2.DIALOGUE
		3: dialogue = DIALOGUE.NPC_3.DIALOGUE
	if !dialogue.is_empty():
		
		if dialogue.size() == 1:
			_unlock_books(customer_num)
			
		return dialogue.pop_front()
	else:
		return []
		
func get_progress() -> Array[int]:
	var progress: Array[int] = []
	progress.append(DIALOGUE.NPC_1.DIALOGUE.size())
	progress.append(DIALOGUE.NPC_2.DIALOGUE.size())
	progress.append(DIALOGUE.NPC_3.DIALOGUE.size())
	
	return progress
	
	
func set_progress(saved_progress: Array[int]) -> void:
	var dialogue_array: Array[Array] = [DIALOGUE.NPC_1.DIALOGUE, DIALOGUE.NPC_2.DIALOGUE, DIALOGUE.NPC_3.DIALOGUE]
	for i in len(saved_progress):
		var resize_count := saved_progress[i]
		while resize_count > 0:
			dialogue_array[i].remove_at(0)
			resize_count -= 1

func generic_order(drink: Drink) -> String:
	return GREET.pick_random() + BEGIN.pick_random() + drink.name + WITH + _get_flavor(drink.tea_flavor)

func _unlock_books(customer_num: int) -> void:
	var books: Array = []
	match customer_num:
		1: if DIALOGUE.NPC_1.UNLOCK == false:
			books = DIALOGUE.NPC_1.BOOKS
		2: if DIALOGUE.NPC_2.UNLOCK == false:
			books = DIALOGUE.NPC_2.BOOKS
		3: if DIALOGUE.NPC_3.UNLOCK == false:
			books = DIALOGUE.NPC_3.BOOKS
			
	if books.is_empty():
		print("Cant unlock")
		return
	else:
		print("Unlock")
		for index in books:
			Dynamic.unlocked_book[index] = index + 1
		books_reload.emit()
	
func _get_flavor(flavor_num: int) -> String:
	var flavor: String
	match flavor_num:
		Static.TEA.ASSAM:
			flavor = "Assam black."
		Static.TEA.CEYLON:
			flavor = "Ceylon black."
		Static.TEA.CHAI:
			flavor = "Chai."
		Static.TEA.EARL_GREY:
			flavor = "Earl grey."
		Static.TEA.HOJICHA:
			flavor = "Hojicha green."
		Static.TEA.JASMINE:
			flavor = "Jasmine green."
		Static.TEA.MINT:
			flavor = "Morrocan Mint green."
		Static.TEA.SENCHA:
			flavor = "Sencha green."
		Static.TEA.OOLONG:
			flavor = "Oolong."
		Static.TEA.MATCHA:
			flavor = "Matcha."
		Static.TEA.TARO:
			flavor = "Taro."
	return flavor
