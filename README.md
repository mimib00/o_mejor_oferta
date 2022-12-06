# O Mejor Oferta

An open source annotation tool built using dart and flutter framework.

## Folder Structure - folder by screens

The point of a structure is to make it easy to find stuff & make changes as new requirements arise. A good structure does this for both experienced and new developers.

- `core`:

  _Contains App Services, Api Calls, Localization etc., All API, GPS data, Cache etc are fetched from here_

  - `config`- _Contains all the configuration files for the app._
  - `localization`- _Contains all the localization files for the app._
  - `routes` - _Contains all the routes for the app._
  - `controllers`- _All the globally used controllers for the app._
  - `theme`- _Contains the global app theme data._

- `gen`:
  _Contains Asset generated bundle_

- `meta`:

  _Contains pages, widgets, utils etc that are common for multiple features. For example: a Custom Loading indicator, Error Pages, Get location function etc_

  - `widgets` - _Contains globally used widgets for the app._
  - `utils` - _Contains globally used utils for the app._
  - `models` - _Model classes for the app._

- `views`:

  _UI Screens having a separate controller assigned to each of them_

  - `view A` - _Can be any screen Ex. `home_screen`_
    - `components` - _Contains all the components for the `screen A`._
    - `controllers` - _Contains all the controllers for the `screen A`._
    - `screens` - _Contains all the views for the `screen A`, Ex. A page is having multiple tabs_
      - `tab A` - _Can be any tab Ex. `home_tab`_
        - `components` - _Contains all the components for the `tab A`._
        - `controllers` - _Contains all the controllers for the `tab A`._

## Flutter App Coding Guidelines:

- Using latest stable version of Flutter `3.0.1`.
- ![image](https://user-images.githubusercontent.com/90178033/172199999-a1322107-f464-48fa-802c-2f04aa05071f.png)
- Use `lower_case_file_names.dart`.
- Minimize use of stateful widgets.
- Use `const` for all constants.
- Minimize use of `setState()`.
- Use Named Routes for all the screens.
- Use line length `120` for dart files.
- ![image](https://user-images.githubusercontent.com/90178033/172284528-a9552834-4875-487d-8483-637b376b6a2f.png)

## Used Packages:

- `get` - State Management, Localization, Theming, etc.
- `sizer` - Screen size utility for Responsive Design.
- `dio` - To manage Http requests.
- `google_fonts` - To have access to fonts.
