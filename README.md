# **NetStream** - *Concepteur développeur d'Application*
### *Contexte du projet*
Dans le cadre de notre apprentissage de Merise, nous avons pour tâche de concevoir une base de données Postgres en la déployant via un environnement Docker. Il nous est également demandé des requêtes exemples, disponible dans ce readme.
___
### *Technologies utilisées*
![DOCKER](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![POSTGRES](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
___
### *Installation du projet*
Ouvrez un terminal et naviguez vers le répertoire "*Database*".

Exécutez la commande :
```cmd
docker compose up
```
Utilisez un SGBD (compatible postgresql) pour interagir avec la base de données.

Deux login sont disponible :
- Super Admin : *login* : **sarah**, *mdp* : **Oxymore59230**
- Utilisateur : *login* : **Client**, *mdp* : **clientPassword**
___
### *Contributeur.ices*

<a href="https://github.com/Sarah-Katz"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></img></a>
<a href="https://www.linkedin.com/in/sarah-katz-dev/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></img></a>
<a href="https://www.codewars.com/users/SarahKatz"><img src="https://img.shields.io/badge/Codewars-B1361E?style=for-the-badge&logo=Codewars&logoColor=white"></img></a>
___
# Requêtes SQL

 ### Les titres et dates de sortie des films du plus récent au plus ancien

 ```sql
 SELECT title, release_date
 FROM Public."Movie"
 ORDER BY release_date DESC;
 ```
 ### Les noms, prénoms et âges des acteurs/actrices de plus de 30ans dans l'ordre alphabétique

 ```sql
 SELECT actor_lastname, actor_firstname, age(CURRENT_TIMESTAMP, birth_date)
 FROM Public."Actor"
 WHERE age(CURRENT_TIMESTAMP, birth_date) > age(CURRENT_TIMESTAMP, '1993-01-01')
 ORDER BY actor_lastname;
 ```
 ### La liste des acteurs/actrices principaux pour un film donné
 
 ```sql
 SELECT actor_lastname, actor_firstname, role, title
 FROM Public."Act" ac 
 INNER JOIN Public."Actor" a
 ON a.id_actor = ac.id_actor
 INNER JOIN Public."Movie" m
 ON m.id_movie = ac.id_movie
 WHERE title = 'The Lost City';
 ```
 ### La liste des films pour un acteur/actrice donné
 
 ```sql
 SELECT actor_lastname, actor_firstname, role, title
 FROM Public."Act" ac 
 INNER JOIN Public."Actor" a
 ON a.id_actor = ac.id_actor
 INNER JOIN Public."Movie" m
 ON m.id_movie = ac.id_movie
 WHERE a.actor_lastname = 'Jones';
 ```
 ### Ajouter un film
 
 ```sql
 INSERT INTO Public."Movie" (title, duration, release_date)
 VALUES ('Un film', 137, '2023-12-19');
 ```
 ### Ajouter un acteur/actrice
 
 ```sql
 INSERT INTO public."Actor"(actor_lastname, actor_firstname, birth_date)
 VALUES ('Christ', 'Jesus', '0000-12-25');
 ```
 ### Modifier un film
 
 ```sql
 UPDATE public."Movie"
 SET title = 'A quoi tu sert ?'
 WHERE id_movie = 1;
 ```
 ### Supprimer un acteur/actrice
 
 ```sql
 DELETE FROM public."Actor"
 WHERE id_actor = 1;
 ```
 ### Afficher les 3 derniers acteurs/actrices ajouté(e)s
 
 ```sql
 SELECT * FROM public."Actor"
 ORDER BY created_at DESC LIMIT 3;
 ```
