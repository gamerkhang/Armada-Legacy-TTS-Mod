# Armada-Legacy-TTS-Mod

This repo contains exported scripts from this Tabletop Simulator mod: https://steamcommunity.com/sharedfiles/filedetails/?id=713586082

To make balance changes, go to the Armada Spawner file, search for the ship that you want to update (The name should match what is provided for the game), and update whatever values you need.
New upgrade cards would require images to be uploaded to imgur.com and their links should be pasted in the same format as other existing cards.
New ships would require new 3D models unless you feel like using existing ones as placeholder.

Todo list:
- [ ] need images for existing ship bases that got updated (eg. MC80s)
- [ ] images for cards that got updated point values (this is many many cards.... for now just trust what your fleet spawner lists for you)
- [ ] cards and models for entirely new ships, squadrons, and upgrades
- [ ] re-tint bases for placeholder ships so that you can identify that they are from the faction you are playing as more easily

Checklist of items that are from Armada Legacy file folders
- [x] Wave 1 - Placeholder version
  - [ ] Ship bases/models for updated ships
    - [x] Arquitens Light Cruiser Expansion
    - [x] Assault Frigate Mark I Expansion
    - [x] Dreadnaught Heavy Cruiser Expansion
    - [x] Trident Assault Ship Expansion
  - [ ] Squadron bases/models for new squadrons
    - [x] Hotshots and Aces Expansion
    - [x] Republic Fighter Pack II
    - [x] Separatists Fighter Pack II

Known bugs:
-Both the Anakin ETA-2 squadron and Anakin Delta squadron are 24 points, which causes conflict in fleet spawner parser as both use "Anakin Skywalker (24)". Temporary workaround was to make the ETA-2 version 23 points.
