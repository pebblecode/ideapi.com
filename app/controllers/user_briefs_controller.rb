class UserBriefsController < ApplicationController
  def create
    @user_brief = UserBrief.create(params[:user_brief])
    if @user_brief.save
      
      respond_to do |format|
        format.html{
          flash[:notice] = "#{@user_brief.user.full_name} has been added to the brief."
          redirect_to @user_brief.brief
        }
        format.js{
          render :partial => 'briefs/update_collaborators_form', :locals => {:current_object => @user_brief.brief}
        }
      end
    else
      respond_to do |format|
        format.html{
          
        }
        format.js{
          render :text => 'ERROR'
        }
      end
    end
  end
  
  def update
    begin
      @user_brief = UserBrief.find(params[:id])
      @brief = @user_brief.brief
      if @user_brief.update_attributes(params[:user_brief])
        respond_to do |format|
          format.html{
            flash[:notice] = 'User role updated.'
            redirect_to @brief and return
          }
          format.js{
            render :partial => 'briefs/update_collaborators_form', :locals => {:current_object => @brief}
          }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html{
          flash[:error] = 'The user is no longer in this brief.'
          redirect_to dashboard_url and return
        }
        format.js{
          render :text => 'Record not found.' and return
        }
      end
    end
  end
  
  def destroy
    begin
      @user_brief = UserBrief.find(params[:id])
      @brief = @user_brief.brief
      if @user_brief.destroy
        respond_to do |format|
          format.html{
            flash[:notice] = 'User removed from brief.'
            redirect_to @brief and return
          }
          format.js{
            render :partial => 'briefs/update_collaborators_form', :locals => {:current_object => @brief}
          }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html{
          flash[:error] = 'The user is no longer in this brief.'
          redirect_to dashboard_url and return
        }
        format.js{
          render :text => 'Record not found.' and return
        }
      end
    end
  end
  
end