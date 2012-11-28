class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    
    body = params['Body'].gsub(/[^0-9]/, "")
    from = params['From']

    Venue.location_search(body, from)

    respond_to do |format|
      format.xml
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
  end
end