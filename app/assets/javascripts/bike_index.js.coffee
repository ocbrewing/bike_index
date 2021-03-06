window.BikeIndex =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->

  hideFlash:() ->
    # Fade out hovering alerts after 10 seconds
    setTimeout("$('#alert-block').fadeOut('slow')", 10000)

  alertMessage:(type, title, message) ->
    $('#alert-block>div').addClass("hidden")
    $('#alert-block').css('display', 'block')
    $('#alert-block').append("""
        <div class="alert-#{type}" data-alert="alert">
          <a class="close" data-dismiss="alert" href="#">×</a>
          <h4>#{title}</h4>
          <div class="padded">#{message}</div>
        </div>
      """)
    BikeIndex.hideFlash()

    links = links + "</ul></div>"
    
    # $('#total-top-header .global-tabs').append(tab)
    # $('#total-top-header .tab-content').append(links)

$(document).ready ->
  view = new BikeIndex.Views.Global
  
  if $('#home_headies').length > 0
    view = new BikeIndex.Views.Home 
  if $('#news_display').length > 0
    view = new BikeIndex.Views.NewsDisplay 

  else if $('#documentation-menu').length > 0
    view = new BikeIndex.Views.DocumentationIndex

  else if $('#content-wrap').length > 0
    if $('#where-bike-index').length > 0
      view = new BikeIndex.Views.ContentWhere
    if $('#manufacturers-list').length > 0
      view = new BikeIndex.Views.ContentManufacturers
  
  if $('#stripe_form').length > 0
    view = new BikeIndex.Views.PaymentsForm

  else if $('#choose-registration-type').length > 0
    view = new BikeIndex.Views.BikesChooseRegistration

  else if $('#bikes-search').length > 0
    view = new BikeIndex.Views.BikesSearch

  else if $('#bike-show').length > 0
    view = new BikeIndex.Views.BikesShow

  else if $('#photos-flip').length > 0
    view = new BikeIndex.Views.LoginSignup

  else if $('#organization-content').length > 0
    view = new BikeIndex.Views.OrganizationsShow

  else if $('#user-home-page').length > 0
    view = new BikeIndex.Views.DataTables
  
  else if $('#edit-bike-form').length > 0
    view = new BikeIndex.Views.BikesEdit

  else if $('#edit-user-form').length > 0
    view = new BikeIndex.Views.UsersEdit

  else if $('#lock-form').length > 0
    view = new BikeIndex.Views.LocksForm

  else if $('#new_bike').length > 0
    view = new BikeIndex.Views.BikesNew

  else if $('#admin-content').length > 0
    view = new BikeIndex.Views.DataTables
    if $('#bike_edit_root_url').length > 0
      view = new BikeIndex.Views.AdminBikesEdit
    else if $('#admin-locations-fields').length > 0
      view = new BikeIndex.Views.AdminOrganizationsEdit
    else if $('#admin-recoveries').length > 0
      view = new BikeIndex.Views.AdminRecoveries
    else if $('#blog-edit').length > 0
      view = new BikeIndex.Views.AdminBlogsEdit
    else if $('#graph-holder').length > 0
      view = new BikeIndex.Views.AdminGraphs
  
  else if $('#photo-page').length > 0
    view = new BikeIndex.Views.PhotosIndex

  else if $('#multi_serial_search').length > 0
    view = new BikeIndex.Views.StolenMultiSerialSearch
    
