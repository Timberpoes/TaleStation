// -- Helper procs and hooks for pain. --
/mob/living/carbon
	/// The pain controller datum - tracks, processes, and handles pain.
	/// Only initialized on humans, but this variable is on carbons for ease.
	var/datum/pain/pain_controller

/mob/living/carbon/Initialize(mapload)
	. = ..()
	pain_controller = new /datum/pain(src)

/mob/living/carbon/Destroy()
	if(pain_controller)
		QDEL_NULL(pain_controller)
	return ..()

/*
 * Cause [amount] of [dam_type] sharp pain to [target_zones].
 * Sharp pain is for sudden spikes of pain that go away after [duration] deciseconds.
 */
/mob/living/carbon/proc/sharp_pain(target_zones, amount = 0, dam_type = BRUTE, duration = 1 MINUTES)
	if(!islist(target_zones))
		target_zones = list(target_zones)
	for(var/zone in target_zones)
		apply_status_effect(/datum/status_effect/sharp_pain, zone, amount, dam_type, duration)

/*
 * Set [id] pain modifier to [amount], and
 * unset it automatically after [time] deciseconds have elapsed.
 */
/mob/living/carbon/proc/set_timed_pain_mod(id, amount = 0, time = 0)
	if(time <= 0)
		return
	set_pain_mod(id, amount)
	addtimer(CALLBACK(pain_controller, /datum/pain.proc/unset_pain_modifier, id), time)

/*
 * Returns the bodypart pain of [zone].
 * If [get_modified] is TRUE, returns the bodypart's pain multiplied by any modifiers affecting it.
 */
/mob/living/carbon/proc/get_bodypart_pain(target_zone, get_modified = FALSE)
	var/obj/item/bodypart/checked_bodypart = pain_controller?.body_zones[target_zone]
	if(!checked_bodypart)
		return 0

	return get_modified ? checked_bodypart.get_modified_pain() : checked_bodypart.pain
