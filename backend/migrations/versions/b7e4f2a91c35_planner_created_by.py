"""planner created_by

Revision ID: b7e4f2a91c35
Revises: 0b10d67750be
Create Date: 2026-11-06 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b7e4f2a91c35'
down_revision = '0b10d67750be'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('planner', schema=None) as batch_op:
        batch_op.add_column(sa.Column('created_by', sa.Integer(), nullable=True))
        batch_op.create_foreign_key(
            batch_op.f('fk_planner_created_by_user'),
            'user',
            ['created_by'],
            ['id'],
        )


def downgrade():
    with op.batch_alter_table('planner', schema=None) as batch_op:
        batch_op.drop_constraint(batch_op.f('fk_planner_created_by_user'), type_='foreignkey')
        batch_op.drop_column('created_by')
