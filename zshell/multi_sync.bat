git remote remove gitee_notes
git remote remove github_notes
git remote remove coding_notes

git remote add gitee_notes git@gitee.com:Eyestorm/notes.git
git remote add github_notes git@github.com:Estom/notes.git
git remote add coding_notes git@e.coding.net:cloudengine/notes/notes.git


git pull gitee_notes  master
git pull github_notes master
git pull coding_notes master

git add * 
git commit -m $date

git push gitee_notes
git push github_notes
git push coding_notes