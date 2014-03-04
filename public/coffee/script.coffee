
angular.module("athreadofsomething",[
  "ngRoute"
  "firebase"
]).config(($routeProvider)->
  $routeProvider.when '/rsvp-responses/:loc',
    templateUrl: "responseList.html"
    controller: "RsvpListCtrl"

  .when '/:scrollTo',
    templateUrl: "main.html"

  .otherwise
    templateUrl: "main.html"

).controller("RsvpCtrl", ($scope)->
  $scope.rsvp =
    attending: true

  ref = new Firebase('https://athreadofsomething.firebaseio.com/accepting/')
  ref.on('value', (snap)-> $scope.$apply () ->
    $scope.showRsvp = snap.val()
  )

).controller("RsvpListCtrl", ($scope, $routeParams, $firebase) ->
  ref = new Firebase("https://athreadofsomething.firebaseio.com/rsvp/#{$routeParams.loc}")
  $scope.responses = $firebase(ref)
  $scope.loc = $routeParams.loc

).directive("firebaseForm", ($firebase)->

  restrict: "A"
  replace: true
  transclude: true

  template: """
    <div class="firebase-form">
      <div class="message error" ng-show="error">
        {{errorMsg}}
      </div>

      <form ng-show="error || (!success && !saving)" ng-transclude>
      </form>

      <div class="message waiting" ng-show="saving">
        {{waitingMsg}}
      </div>
      <div class="message success" ng-show="success">
        {{successMsg}}
      </div>

    </div>

  """


  link: (scope, element, attrs)->

    db = new Firebase(attrs.firebaseUrl)

    scope.waitingMsg = attrs.waitingMsg ? "Saving..."
    scope.successMsg = attrs.successMsg ? "Thank you. Your response has been saved."
    scope.errorMsg = attrs.errorMsg ? "There was a problem saving your response."

    scope.saving = null
    scope.success = null
    scope.error = null


    scope.save = ()->
      data = scope.$eval(attrs.firebaseFormData)
      scope.saving = true
      newRef = db.push()
      newRef.set(data, (error) -> scope.$apply () ->
        scope.saving = false
        if error?
          scope.error = error
        else
          scope.success = true
      )
).directive("stickyNav", ()->
  # This is super quick and dirty -- obviously would be better to make this a generalizable
  # directive.
  restrict: "A"
  link: (scope, element, attrs)->
    $ ()->
      $('nav').waypoint('sticky')

      ###
      Code below borrowed from https://github.com/bmgdev/responsive-wedding/blob/master/js/main-1.6.js
      Copyright © Scal.io, LLC Bradley Greenwood
      ###
      navigation_listItems = $('nav li')
      navigation_links = $('nav li a')

      $('#container>section').waypoint
        handler: (direction) ->
          console.log $(this).attr("id")
          console.log direction
          active_section = undefined
          active_section = $(this)
          active_section = active_section.prev()  if direction is "up"
          active_listItem = $("nav a[href=\"#" + active_section.attr("id") + "\"]").parent()
          navigation_listItems.removeClass "selected"
          active_listItem.addClass "selected"
          return



      navigation_links.click (event) ->
        newActive = $(this)
        $.scrollTo $(this).attr("href"),
          duration: 1000
          offset:
            left: 0
            top: -0.08 * $(window).height()
          onAfter: ()->
            navigation_listItems.removeClass "selected"
            newActive.parent().addClass "selected"


        event.preventDefault()
        return
)
