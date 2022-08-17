/**
 * Attempts to ui_interact the paper to the given user.
 */
/obj/item/paper/proc/show_from_chat(mob/living/user)
	if(!can_show_to_mob_from_chat(user))
		return

	return ui_interact(user)

/**
 * Checks to make sure the user is an observer or admin.
 */
/obj/item/paper/proc/can_show_to_mob_from_chat(mob/living/user)
	if(!user)
		return FALSE

	return (isobserver(user) || is_admin(user.client))
