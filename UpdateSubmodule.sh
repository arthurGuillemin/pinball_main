#ligne a coller pour mettre a jour les submodules d'un coup :

cd pinball_playglass && git pull origin main && cd .. && cd pinball_backend && git pull origin main && cd .. && cd pinball_backglass && git pull origin main && cd .. && cd pinball_dmd && git pull origin main && cd .. && cd pinball_esp32 && git pull origin main && cd .. 

git add . && git commit -m "update submodules with ... latest modifications " && git push