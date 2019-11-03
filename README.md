# freemind2githubissues

__Status: Proof of  concept__

Консольное приложение для преобразования mind map в github issues. 

## Требования

- MindMap в формате freemind (расширение *.mm) на основе шаблона `IssuesTemplate.mm`

- GitHub аккаунт, репозиторий в котором нужно создать issues, apikey (с доступом repo)

- OneScript 1.1 для использования .ospx (http://oscript.io)

_ИЛИ_

- Windows: .Net 3.5 и старше для использования .exe  
-  Linux/Mac: Mono 6.4 и старше для использования .exe

## Команды

```
import - Отправляет данные из карты в гитхаб
Параметры:
 <файл> - Файл freemind (*.mm) или xml файл нужной стркутры
 -u - Владелец репозитория
 -r - Репозиторий
 -k - Apikey пользователя с доступом на пуш в репозиторий (разрешение repo)
 ```

Windows
```
freemind2githubissues-01.exe import mindmap.mm -u testuser -r testrepo -k 50csss3qa5sf450sfseqwe93eb2879a046ba954e
```
Linux/Mac
```
mono freemind2githubissues-01.exe import mindmap.mm -u testuser -r testrepo -k 50csss3qa5sf450sfseqwe93eb2879a046ba954e
```

## Установка

`opm install freemind2githubissues-0.1.ospx`


